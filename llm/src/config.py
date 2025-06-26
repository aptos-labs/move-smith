import os
from pathlib import Path

from dynaconf import Dynaconf

ROOT = Path(__file__).resolve().parent.parent
DATA_DIR = ROOT / "data"
APTOS_CORE_DIR = ROOT.parent.parent / "aptos-core"
MOVE_SMITH_DIR = ROOT.parent

custom_settings_file = os.getenv("SETTINGS")
settings_files = [
    Path(custom_settings_file).resolve() if custom_settings_file else (ROOT / "settings.toml").resolve(),
    (ROOT / ".secrets.toml").resolve(),
]

cfg = Dynaconf(
    envvar_prefix="LLMFUZZ",
    settings_files=settings_files,
)
