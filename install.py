import os
import subprocess
import sys

GITHUB="git@github.com:jchaffraix/ConfigMisc.git"
# TODO: Allow customization.
# This is hardcoded to match the bash_profile file for now.
PATH="~/Tools/Scripts"

def install_config(path, config, copy=False):
  # Check if the path exists.
  name = config.split("/")[-1]
  dst = path + "/" + name
  print("Config %s, destination: %s" % (config, dst))
  if os.path.exists(dst):
    # Decide what to do.
    while True:
      print("File exist %s: Overwrite/Copy/Skip/Exit [ocsE]: " % dst)
      answer = raw_input()
      if answer in ["e", "E"]:
        sys.exit(-1)
      if answer in ["s", "S"]:
        return
      if answer in ["c", "C"]:
        os.rename(dest, dest + ".bak")
      if answer not in ["o", "O"]:
        print("Unknown input")
        continue
      break

  if copy:
    subprocess.check_call(["cp", config, dst])
  else:
    os.symlink(config, dst)

def install(path):
  # Create the root.
  os.makedirs(path, exist_ok=True)

  # Fetch this repository.
  print("Fetching the config")
  # TODO(Python3): subprocess.run.
  subprocess.check_call(["git", "clone", GITHUB, path])

  # Install the different configuration.
  install_config("~", "/".join([path, "config", ".bash_profile"]))
  
if __name__ == "__main__":
  install(PATH)
