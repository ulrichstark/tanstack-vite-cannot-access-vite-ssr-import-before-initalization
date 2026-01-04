#!/bin/bash

# Binary search to find which TanStack version fixed the SSR import error
# Uses react-start as the primary version to search through

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Available versions (newest first)
REACT_START_VERSIONS=(
    "1.145.4" "1.145.3" "1.145.2" "1.145.1" "1.145.0"
    "1.144.0"
    "1.143.12" "1.143.11" "1.143.10" "1.143.9" "1.143.8" "1.143.7" "1.143.6" "1.143.5" "1.143.4" "1.143.3" "1.143.2" "1.143.1" "1.143.0"
    "1.142.13" "1.142.12" "1.142.11" "1.142.10" "1.142.8" "1.142.7" "1.142.6" "1.142.5" "1.142.4" "1.142.3" "1.142.2" "1.142.1" "1.142.0"
    "1.141.9" "1.141.8" "1.141.7" "1.141.6" "1.141.5" "1.141.4" "1.141.3" "1.141.2" "1.141.1" "1.141.0"
    "1.140.5" "1.140.4" "1.140.3" "1.140.2" "1.140.1" "1.140.0"
    "1.139.14" "1.139.13" "1.139.12" "1.139.11" "1.139.10" "1.139.9" "1.139.8" "1.139.7" "1.139.6" "1.139.5" "1.139.4" "1.139.3" "1.139.2" "1.139.1" "1.139.0"
    "1.138.0" "1.137.0"
    "1.136.18" "1.136.17" "1.136.16" "1.136.15" "1.136.14" "1.136.13" "1.136.11" "1.136.10" "1.136.9" "1.136.8" "1.136.7" "1.136.6" "1.136.5" "1.136.4" "1.136.3" "1.136.2" "1.136.1" "1.136.0"
    "1.135.2" "1.135.1" "1.135.0"
    "1.134.20" "1.134.18" "1.134.17" "1.134.15" "1.134.14" "1.134.13" "1.134.12" "1.134.10" "1.134.9" "1.134.7" "1.134.6" "1.134.5" "1.134.4" "1.134.3" "1.134.2" "1.134.0"
    "1.133.37" "1.133.36" "1.133.35" "1.133.34"
)

REACT_ROUTER_VERSIONS=(
    "1.144.0"
    "1.143.11" "1.143.6" "1.143.4" "1.143.3" "1.143.2"
    "1.142.13" "1.142.11" "1.142.8" "1.142.7" "1.142.6"
    "1.141.8" "1.141.6" "1.141.4" "1.141.2" "1.141.1" "1.141.0"
    "1.140.5" "1.140.1" "1.140.0"
    "1.139.16" "1.139.14" "1.139.13" "1.139.12" "1.139.11" "1.139.10" "1.139.9" "1.139.7" "1.139.6" "1.139.5" "1.139.3" "1.139.1" "1.139.0"
    "1.136.18" "1.136.17" "1.136.16" "1.136.15" "1.136.14" "1.136.13" "1.136.11" "1.136.10" "1.136.9" "1.136.8" "1.136.6" "1.136.5" "1.136.4" "1.136.3" "1.136.2" "1.136.1" "1.136.0"
    "1.135.2" "1.135.0"
    "1.134.20" "1.134.18" "1.134.17" "1.134.15" "1.134.13" "1.134.12" "1.134.9" "1.134.4"
    "1.133.36" "1.133.35" "1.133.32" "1.133.28" "1.133.27" "1.133.25" "1.133.22" "1.133.21" "1.133.20" "1.133.19" "1.133.18" "1.133.15" "1.133.13" "1.133.12" "1.133.10" "1.133.8" "1.133.7" "1.133.3"
    "1.132.47" "1.132.45" "1.132.41"
)

NITRO_VERSIONS=("1.141.0" "1.140.0" "1.139.0" "1.133.19")

# Compare versions: returns 0 if v1 >= v2, 1 otherwise
version_gte() {
    local v1="$1" v2="$2"
    [ "$(printf '%s\n%s' "$v1" "$v2" | sort -V | head -n1)" = "$v2" ]
}

# Find the closest lower or equal version from an array
find_closest_version() {
    local target="$1"
    shift
    local versions=("$@")
    
    for v in "${versions[@]}"; do
        if version_gte "$target" "$v"; then
            echo "$v"
            return
        fi
    done
    echo "${versions[-1]}"
}

# Update package.json with specific versions
update_package_json() {
    local start_ver="$1"
    local router_ver="$2"
    local nitro_ver="$3"
    
    # Use node to update package.json properly
    node -e "
        const fs = require('fs');
        const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
        pkg.dependencies['@tanstack/react-start'] = '$start_ver';
        pkg.dependencies['@tanstack/react-router'] = '$router_ver';
        pkg.dependencies['@tanstack/nitro-v2-vite-plugin'] = '$nitro_ver';
        fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n');
    "
}

# Test a specific version, returns 0 if bug exists, 1 if fixed
test_version() {
    local idx="$1"
    local start_ver="${REACT_START_VERSIONS[$idx]}"
    local router_ver=$(find_closest_version "$start_ver" "${REACT_ROUTER_VERSIONS[@]}")
    local nitro_ver=$(find_closest_version "$start_ver" "${NITRO_VERSIONS[@]}")
    
    echo ""
    echo "============================================"
    echo "Testing index $idx:"
    echo "  @tanstack/react-start: $start_ver"
    echo "  @tanstack/react-router: $router_ver"
    echo "  @tanstack/nitro-v2-vite-plugin: $nitro_ver"
    echo "============================================"
    
    update_package_json "$start_ver" "$router_ver" "$nitro_ver"
    
    echo "Running npm install..."
    rm -rf node_modules package-lock.json
    if ! npm install --silent 2>/dev/null; then
        echo "npm install failed, treating as inconclusive"
        return 2
    fi
    
    echo "Running reproduce-error.sh..."
    if ./reproduce-error.sh; then
        echo ">>> BUG EXISTS in version $start_ver"
        return 0
    else
        echo ">>> BUG FIXED in version $start_ver"
        return 1
    fi
}

# Binary search
binary_search() {
    local left=0
    local right=$((${#REACT_START_VERSIONS[@]} - 1))
    local last_buggy=-1
    local last_fixed=-1
    
    echo "Starting binary search across ${#REACT_START_VERSIONS[@]} versions..."
    echo "Versions range from ${REACT_START_VERSIONS[$right]} (oldest) to ${REACT_START_VERSIONS[0]} (newest)"
    
    while [ $left -le $right ]; do
        local mid=$(( (left + right) / 2 ))
        echo ""
        echo ">>> Binary search: left=$left, mid=$mid, right=$right"
        
        test_version $mid
        local result=$?
        
        if [ $result -eq 2 ]; then
            # Inconclusive, try next version
            left=$((mid + 1))
            continue
        elif [ $result -eq 0 ]; then
            # Bug exists, search newer versions (lower indices)
            last_buggy=$mid
            right=$((mid - 1))
        else
            # Bug fixed, search older versions (higher indices)
            last_fixed=$mid
            left=$((mid + 1))
        fi
    done
    
    echo ""
    echo "============================================"
    echo "BINARY SEARCH COMPLETE"
    echo "============================================"
    
    if [ $last_fixed -ne -1 ] && [ $last_buggy -ne -1 ]; then
        echo "Bug was FIXED between:"
        echo "  ${REACT_START_VERSIONS[$last_buggy]} (has bug)"
        echo "  ${REACT_START_VERSIONS[$last_fixed]} (fixed)"
        echo ""
        echo "First version without the bug: ${REACT_START_VERSIONS[$last_fixed]}"
    elif [ $last_fixed -ne -1 ]; then
        echo "Bug is fixed in all tested versions up to ${REACT_START_VERSIONS[$last_fixed]}"
    elif [ $last_buggy -ne -1 ]; then
        echo "Bug exists in all tested versions from ${REACT_START_VERSIONS[$last_buggy]}"
    else
        echo "Could not determine fix version"
    fi
}

# Main
binary_search
