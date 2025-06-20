from pathlib import Path

from dynaconf import Dynaconf

ROOT = Path(__file__).resolve().parent.parent
DATA_DIR = ROOT / "data"
APTOS_CORE_DIR = ROOT.parent.parent / "aptos-core"
MOVE_SMITH_DIR = ROOT.parent

cfg = Dynaconf(
    envvar_prefix="DYNACONF",
    settings_files=[
        (ROOT / "settings.toml").resolve(),
        (ROOT / ".secrets.toml").resolve(),
    ],
)
