import re
from pathlib import Path

from loguru import logger
from pydantic import BaseModel


class MarkdownChunk(BaseModel):
    title: str
    content: str


class MarkdownFile(BaseModel):
    path: Path
    chunks: list[MarkdownChunk]


def parse_markdown_sections(content: str) -> list[MarkdownChunk]:
    sections = []
    lines = content.split("\n")

    current_chunk_lines = []
    current_title = ""

    for line in lines:
        header_match = re.match(r"^(#{1,6})\s+(.+)$", line.strip())

        if header_match and len(current_chunk_lines) > 3:
            if current_chunk_lines:
                chunk_content = "\n".join(current_chunk_lines).strip()
                if chunk_content:
                    sections.append(MarkdownChunk(title=current_title, content=chunk_content))

            current_title = header_match.group(2).strip()
            current_chunk_lines = [line]
        else:
            current_chunk_lines.append(line)

    # Save final chunk
    if current_chunk_lines:
        chunk_content = "\n".join(current_chunk_lines).strip()
        if chunk_content:
            sections.append(MarkdownChunk(title=current_title, content=chunk_content))

    return sections


def parse_markdown_in_dir(path: str | Path) -> list[MarkdownFile]:
    path = Path(path)
    parsed_files = []

    md_files = list(path.rglob("*.md"))
    md_files.extend(list(path.rglob("*.mdx")))
    logger.info(f"Found {len(md_files)} markdown files in {path}")

    for f in md_files:
        content = f.read_text()
        sections = parse_markdown_sections(content)
        parsed_files.append(MarkdownFile(path=f, chunks=sections))

    return parsed_files


if __name__ == "__main__":
    from ..config import DATA_DIR

    example_path = DATA_DIR / "deps/book/src"
    # example_path = DATA_DIR / "deps/developer-docs/apps/nextra/pages/en/build/smart-contracts/book"
    parsed_files = parse_markdown_in_dir(example_path)
    for file in parsed_files:
        logger.info(f"Parsed {file.path.name} with {len(file.chunks)} sections.")
        for chunk in file.chunks:
            print("--------------- CHUNK START ---------------")
            print(f"Title: {chunk.title}")
            print(f"Content: {chunk.content}")
            print("--------------- CHUNK END -----------------")
