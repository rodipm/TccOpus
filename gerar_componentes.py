import os
import re
from shutil import copyfile

path_componentes = os.path.join(".", "ComponentesEip")
path_componentes_back = os.path.join(".", "back", "code_generation", "eip_components")
path_componentes_front = os.path.join(".", "front", "lib", "EipWidgets")

components = os.listdir(path_componentes)

pattern = re.compile(r'(?<!^)(?=[A-Z])')

imports_file_back = []

for component in components:
    file_base_name = pattern.sub('_', component).lower()
    file_py = file_base_name + ".py"
    file_dart = file_base_name + ".dart"

    # Copia os arquivos .py para o diretorio no back-end
    copyfile(os.path.join(path_componentes, component, file_py),
             os.path.join(path_componentes_back, file_py))

    imports_file_back.append(f"from .{file_base_name} import {component}")

    # Imagens para os assets do front
    copyfile(os.path.join(path_componentes, component, component + ".png"),
             os.path.join(".", "front", "assets", component + ".png"))

# Cria o documento de imports de componentes do backend
with open(os.path.join(path_componentes_back, "components_imports.py"), "w") as f:
    f.write("\n".join(imports_file_back))
