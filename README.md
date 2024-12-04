# Colcon Anywhere Build

A Bash wrapper script for the `colcon` command, allowing you to execute it from anywhere within a workspace directory. Meant as a quick-fix solution.

This script uses the environment variable `WORKSPACE_KEYWORD` to identify workspaces based on your naming conventions. It checks if you are in the root directory of a workspace. If not, it traverses up the directory tree to find the root, changes to that directory, runs `colcon build`, and then returns to your original directory.

# TLDR Installation Assuming `.bashrc` is in the Home Folder `~/`

1. Clone the repo to `~/`
```
mkdir -p ~/.colcon_anywhere_build && git clone git@github.com:CJans121/.colcon_anywhere_build.git ~/.colcon_anywhere_build
```

2. Set the `WORKSPACE_KEYWORD` environment variable and source the script
```
echo "export WORKSPACE_KEYWORD=ws" >> ~/.bashrc && # if not ws, replace with your workspace keyword
echo "source ~/.colcon_anywhere_build/colcon_anywhere_build.sh" >> ~/.bashrc &&
source ~/.bashrc  # to apply the changes immediately
```

3. Now you can run `colcon build` as usual, with or without additional flags, from any location inside the workspace directory.

## Additional Details

Setting the `WORKSPACE_KEYWORD` environment variable. Here are some examples:
   - If you name your workspaces `ros2_ws`, `ws_ros2`, etc., `export WORKSPACE_KEYWORD=ws`
   - If you name your workspaces `workspace_ros2`, `ros2_workspace`, etc., `export WORKSPACE_KEYWORD=workspace`

### Covered Workspace Naming Conventions
The script recognizes workspace directories with names matching these patterns:
- `${WORKSPACE_KEYWORD}_<something>`
- `<something>_${WORKSPACE_KEYWORD}`
- `<something>_${WORKSPACE_KEYWORD}_<something>`
- `${WORKSPACE_KEYWORD}`

## Author
Crasun Jans
