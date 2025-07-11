import subprocess
import platform

def run_command(instruction: str) -> str:
    try:
        if "open" in instruction:
            app = instruction.replace("open", "").strip()
            if platform.system() == "Windows":
                subprocess.Popen(["start", app], shell=True)
            elif platform.system() == "Darwin":
                subprocess.Popen(["open", "-a", app])
            else:
                subprocess.Popen([app])
            return f"Opening {app}"
        else:
            result = subprocess.check_output(instruction, shell=True)
            return result.decode()
    except Exception as e:
        return str(e)
