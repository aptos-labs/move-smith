import re
from pathlib import Path

from loguru import logger

from ..config import DATA_DIR, cfg
from ..feature import Feature, FeatureType
from ..feature_store import FeatureComboStore
from ..helper import run_in_parallel
from .common import COMMON_PROMPT, common_invoke_llm

FEATURE_MARKDOWN_FILE = DATA_DIR / "feature_markdown.json"

# Default markdown directories to search
MARKDOWN_DIRECTORIES = [
    DATA_DIR / "deps/developer-docs/apps/nextra/pages/en/build/smart-contracts/book",
    DATA_DIR / "deps/book/src",
]


def parse_markdown_sections(content: str) -> list[tuple[str, str]]:
    """
    Parse markdown content into sections based on headers and paragraphs.

    Returns:
        List of tuples: (section_type, title, content)
        section_type can be 'header', 'paragraph', or 'code_block'
    """
    sections = []
    lines = content.split("\n")
    current_section = []
    current_header = ""
    current_type = "paragraph"
    in_code_block = False
    code_block_lang = ""

    for line in lines:
        # Check for code blocks
        if line.strip().startswith("```"):
            if not in_code_block:
                # Starting a code block
                in_code_block = True
                code_block_lang = line.strip()[3:].strip()
                if current_section:
                    # Save previous section
                    content_text = "\n".join(current_section).strip()
                    if content_text:
                        sections.append((current_header, content_text))
                    current_section = []
                current_type = "code_block"
                current_header = f"Code Block ({code_block_lang})" if code_block_lang else "Code Block"
                current_section.append(line)
            else:
                # Ending a code block
                current_section.append(line)
                content_text = "\n".join(current_section).strip()
                if content_text:
                    sections.append((current_header, content_text))
                current_section = []
                current_type = "paragraph"
                current_header = ""
                in_code_block = False
                code_block_lang = ""
            continue

        if in_code_block:
            current_section.append(line)
            continue

        # Check for headers
        header_match = re.match(r"^(#{1,6})\s+(.+)$", line.strip())
        if header_match:
            if current_section:
                content_text = "\n".join(current_section).strip()
                if content_text:
                    sections.append((current_header, content_text))
                current_section = []

            header_title = header_match.group(2).strip()
            current_header = header_title
            current_type = "header"
            current_section.append(line)
        else:
            # Regular content line
            if line.strip() == "":
                # Empty line - check if we should end current section
                if current_section and current_type == "paragraph":
                    # End current paragraph if it has content
                    content_text = "\n".join(current_section).strip()
                    if content_text:
                        sections.append((current_header, content_text))
                        current_section = []
                        current_header = ""
                elif current_type == "header":
                    # Headers can have empty lines
                    current_section.append(line)
            else:
                # Non-empty line
                if current_type == "header" and current_section:
                    # Switch from header to content
                    content_text = "\n".join(current_section).strip()
                    if content_text:
                        sections.append((current_header, content_text))
                    current_section = [line]
                    current_type = "paragraph"
                else:
                    current_section.append(line)

    # Save final section
    if current_section:
        content_text = "\n".join(current_section).strip()
        if content_text:
            sections.append((current_header, content_text))

    return sections


def extract_feature_from_markdown_section(section_data: tuple[str, str, Path]) -> list[str]:
    """
    Extracts features from a markdown section using LLM.
    """
    title, content, file_path = section_data

    logger.info(f"Extracting feature from {file_path.name} - {title[:50]}...")

    msg = f"""Below is a section from Move documentation or reference material.

File: {file_path}
Title: {title}

Content:
```
{content}
```

{COMMON_PROMPT}"""

    response = common_invoke_llm("move_book", msg, 0.01)

    return response.descriptions if response else []


def extract_features_from_markdown_files(regenerate: bool) -> FeatureComboStore:
    """
    Extract features from markdown files in specified directories.
    """
    directories = MARKDOWN_DIRECTORIES

    # Find all markdown files
    all_markdown_files = []
    for directory in directories:
        if directory.exists():
            all_markdown_files.extend(list(directory.rglob("*.md")))
            all_markdown_files.extend(list(directory.rglob("*.mdx")))

    logger.info(f"Found {len(all_markdown_files)} markdown files")

    if FEATURE_MARKDOWN_FILE.exists() and not regenerate:
        logger.info(f"Loading features from {FEATURE_MARKDOWN_FILE}")
        feature_combo_store = FeatureComboStore("markdown")
        feature_combo_store.load_combo_store_from_file(FEATURE_MARKDOWN_FILE)
        num_features = len(feature_combo_store.get_all_keys())

        logger.info(f"Loaded {num_features} features from {FEATURE_MARKDOWN_FILE}")
        return feature_combo_store

    if regenerate:
        logger.info(f"Regenerating features for {len(all_markdown_files)} markdown files")
    else:
        logger.info(f"Generating features for {len(all_markdown_files)} markdown files")

    # Parse all markdown files into sections
    all_sections = []
    for md_file in all_markdown_files:
        content = md_file.read_text(encoding="utf-8")
        sections = parse_markdown_sections(content)

        for title, section_content in sections:
            # Skip very short sections
            if len(section_content.strip()) < 50:
                continue
            all_sections.append((title, section_content, md_file))

    logger.info(f"Parsed {len(all_sections)} sections from markdown files")

    # Extract features from sections in parallel
    args = [(section_data,) for section_data in all_sections]
    description_lists = run_in_parallel(cfg.fuzz.jobs, extract_feature_from_markdown_section, args)
    descriptions = [desc for sublist in description_lists for desc in sublist if desc]

    feature_combo_store = FeatureComboStore("markdown")
    feature_count = 0

    for desc, (title, section_content, md_file) in zip(descriptions, all_sections):
        if not desc:
            continue

        # Create content with context
        relative_path = md_file.relative_to(DATA_DIR) if DATA_DIR in md_file.parents else md_file
        content = f"File: {relative_path}\n"
        content += f"Section: {title}\n\n"
        content += f"Content:\n```\n{section_content}\n```\n"

        feature = Feature.new_feature(
            description=desc,
            content=content,
            type=FeatureType.DOCUMENTATION,
        )
        feature_combo_store.add_individual_feature(feature)
        feature_count += 1

    feature_combo_store.save_local(FEATURE_MARKDOWN_FILE, overwrite=True)
    logger.success(f"Saved {feature_count} features to {FEATURE_MARKDOWN_FILE}")

    return feature_combo_store
