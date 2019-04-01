# Script para instalação automatizada do Arch Linux 

> #### **<u>TODAS AS PARTIÇÕES JÁ EXISTENTES SERÃO APAGADAS !**</u>
>

**Esquema de particionamento padrão no script**

| PARTIÇÃO |           TAMANHO           |
| :------: | :-------------------------: |
|  /boot   |            550MB            |
|    /     |            50GB             |
|  /home   | espaço livre restante no HD |

Após estar conectado à internet, realizar os sequintes comandos:

*wget https://raw.githubusercontent.com/marcelobaptista/scripts-linux/master/arch-linux/instala-arch.sh* 
*wget https://raw.githubusercontent.com/marcelobaptista/scripts-linux/master/arch-linux/arch-chroot.sh*

Editar o arquivo **instala-arch.sh** e alterar a seguinte linha:

* *No trecho +50G, alterar para o tamanho desejado para a partição /. O resto do espaço será usado para a partição /home.*

Editar o arquivo **arch-chroot.sh** e alterar as seguintes linhas:

* *Na linha: **sudo useradd -m -G sys,lp,network,video,optical,storage,scanner,power,wheel marcelo**, alterar **marcelo** para o nome de usuário que deseja criar.*
* *Na linha:  **printf "123\n123\n" | passwd marcelo**, trocar **123** pela senha desejada para o usuário anteriormente citado. Também trocar **marcelo** para o nome de usuário anteriormente citado.*

Executar o eseguinte comando: **sh instala-arch.sh** e aguardar o término da instalação. Não será necessária nenhuma interação durante a instalação. Após a instalação automática, seu computador será reiniciado.