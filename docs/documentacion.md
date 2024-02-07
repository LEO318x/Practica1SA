## \\> Instalación de Terraform

---

### Ubuntu

Para realizar la instalación en nuestra distribución de ubuntu necesitamos ejecutar los comandos que se describen a continuación:

1.  Actualizamos nuestros repositorios e instalamos las dependencias necesarias para proceder con la instalación de terraform.
    *   ```plaintext
        sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
        ```
        
2.  Instalamos las credenciales de Hashicorp
    *   ```plaintext
        $ wget -O- https://apt.releases.hashicorp.com/gpg | \
        gpg --dearmor | \
        sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
        ```
        
3.  Verificamos las fingerprints de las keys
    *   ```plaintext
        $ gpg --no-default-keyring \
        --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
        --fingerprint
        ```
        
4.  Añadimos el repositorio oficial de Hashicorp a nuestra lista de repositorios de nuestro sistema
    *   ```plaintext
        $ echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
        https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/hashicorp.list
        ```
        
5.  Actualizamos los repositorios
    *   ```plaintext
        $ sudo apt update
        ```
        
6.  Procedemos a instalar Terraform
    *   ```plaintext
        $ sudo apt-get install terraform
        ```
        
7.  Verificamos la instalación
    *   ```plaintext
        terraform -help
        
        Usage: terraform [-version] [-help] <command> [args]
        
        The available commands for execution are listed below.
        The most common, useful commands are shown first, followed by
        less common or more advanced commands. If you're just getting
        started with Terraform, stick with the common commands. For the
        other commands, please read the help and docs before usage.
        #...
        ```