set -euo pipefail
project_dir=$( cd "${BASH_SOURCE[0]%/*}/.." && pwd )
venv_dir=$project_dir/venv

just_created_venv=false
if [[ ! -d $venv_dir ]]; then
  python3 -m venv "$venv_dir"
  just_created_venv=true
fi

set +u
. "$venv_dir/bin/activate"
if "$just_created_venv"; then
  pip install --upgrade pip
fi
set +u

set +e
pip install -r "$project_dir/requirements.txt" | grep -v "^Requirement already satisfied: "
if [[ ${PIPESTATUS[0]} != 0 ]]; then
  echo >&2 "pip install failed"
  exit 1
fi
set -e

