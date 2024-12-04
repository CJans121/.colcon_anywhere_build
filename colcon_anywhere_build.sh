#!/bin/bash
#
# colcon_anywhere_build.sh
#
# A wrapper script for the `colcon` command, allowing you to execute it from anywhere within a workspace directory.
# The script uses the environment variable `WORKSPACE_KEYWORD` to identify workspaces based on your naming conventions.
# For example:
#   - If you name your workspaces `ros2_ws`, `ws_ros2`, etc., export WORKSPACE_KEYWORD=ws
#   - If you name your workspaces `workspace_ros2`, `ros2_workspace`, etc., export WORKSPACE_KEYWORD=workspace
#
# The script checks if you are in the root of a workspace. If not, it traverses up the directory tree to locate the
# root, changes to that directory, executes `colcon build`, and then returns to your original directory.
#
# Author: Crasun Jans
#
# Usage:
#   1. Set the `WORKSPACE_KEYWORD` environment variable:
#        Example: `export WORKSPACE_KEYWORD=ws`
#   2. Source this script. Add the following line to your `.bashrc` for convenience:
#        `source /path/to/colcon_anywhere_build.sh`
#   3. Run `colcon build` as usual with or without additional flags from any location inside the workspace directory.
#
# Workspace Naming Conventions:
#   The script recognizes workspace directories with names matching these patterns:
#     - `${WORKSPACE_KEYWORD}_<something>`
#     - `<something>_${WORKSPACE_KEYWORD}`
#     - `<something>_${WORKSPACE_KEYWORD}_<something>`
#     - `${WORKSPACE_KEYWORD}`
#

colcon() {
    if [[ "$1" == "build" ]]; then
        # Ensure WORKSPACE_KEYWORD is set
        if [[ -z "$WORKSPACE_KEYWORD" ]]; then
            echo "Error: WORKSPACE_KEYWORD environment variable is not set. Please set it to identify workspace directories."
            echo "Examples: If your workspaces are named 'ros2_ws', 'dev_ws', 'project_ws', 'ws_ros2', '_ws_project', etc., set WORKSPACE_KEYWORD=ws."
            echo "Export it in your shell configuration, e.g., 'export WORKSPACE_KEYWORD=ws'."
            return 1
        fi

        initial_dir=$(pwd)  # Store the initial directory to return to later

        # Traverse directories backward looking for valid naming and structure and execute colcon build at the first directory that matches the requirements
        current_dir=$initial_dir
        while [[ "$current_dir" != "/" ]]; do
	    if [[ $(basename "$current_dir") =~ (^${WORKSPACE_KEYWORD}_|_${WORKSPACE_KEYWORD}_|_${WORKSPACE_KEYWORD}$|^${WORKSPACE_KEYWORD}$) ]]; then

                if [[ ! -d "$current_dir/src" ]]; then
                    echo "Error: Found candidate directory '$current_dir' to colcon build, but it does not contain a 'src' folder."
                    return 1
                fi
                if [[ "$current_dir" != "$initial_dir" ]]; then
                    echo "Executing colcon build at $current_dir"
                fi
                cd "$current_dir" || return
                command colcon build "${@:2}"
                cd "$initial_dir" || return  # Return to the initial directory
                return
            fi
            current_dir=$(dirname "$current_dir")
        done

        echo "Error: No valid workspace directory found to colcon build. Ensure that workspace directories are named using one of the following patterns:"
        echo "     - '${WORKSPACE_KEYWORD}_<something>'"
        echo "     - '<something>_${WORKSPACE_KEYWORD}'"
        echo "     - '<something>_${WORKSPACE_KEYWORD}_<something>'"
        echo "     - '$WORKSPACE_KEYWORD'"
        return 1
    else
        command colcon "$@"
    fi
}
