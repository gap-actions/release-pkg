#!/usr/bin/env bash
set -e
set -o pipefail
error_found=false

reserved_names=(
  con  prn  aux  nul
  com1 com2 com3 com4
  com5 com6 com7 com8
  com9 com¹ com² com³
  lpt1 lpt2 lpt3 lpt4
  lpt5 lpt6 lpt7 lpt8
  lpt9 lpt¹ lpt² lpt³
)

forbidden_chars='[<>:"/\\|?*]'

echo "Checking for Windows-incompatible names"

mapfile -d '' all_paths < <(find . -printf '%P\0' | sort -z || true)
declare -A seen

for p in "${all_paths[@]}"; do
  [[ -z "${p}" ]] && continue # skip empty variable caused by root "."

  base="$(basename "${p}")"
  base_no_ext="${base%%.*}"
  base_no_ext="${base_no_ext,,}"
  lower="${p,,}"
  
  if [[ "${base}" =~ ${forbidden_chars} ]]; then
    echo "  Illegal character in name: ${p}"
    error_found=true
  fi
  
  for reserved in "${reserved_names[@]}"; do
    if [[ "${base_no_ext}" == "${reserved}" ]]; then
      echo "  Reserved Windows name: ${p}"
      error_found=true
    fi
  done

  if [[ "${base}" =~ [\ .]$ ]]; then
    echo "  Name ends with space or period: ${p}"
    error_found=true
  fi
  
  if [[ -n "${seen[${lower}]:-}" ]]; then
    echo "  Duplicate filename: ${seen[${lower}]} and ${p}"
    error_found=true
  else
    seen[${lower}]="${p}"
  fi
done

if ${error_found}; then
  exit 1
fi
