Dragon Builder
Descrição

Dragon Builder é um script Bash para criar uma ISO Linux personalizada compatível com UEFI, baseada no sistema de arquivos root de uma instalação existente. O script gera uma imagem ISO inicializável, copiando o kernel, initramfs, e o sistema de arquivos do root para a ISO, utilizando o grub-mkrescue para garantir a compatibilidade com sistemas UEFI.
Informações Gerais

    Autor: Gabriel S. Ribeiro
    Data de Criação: 21 de Setembro de 2024
    Versão: 1.1

Requisitos

Este script precisa das seguintes ferramentas instaladas:

    grub-efi-amd64-bin: Utilizado para criar a ISO com suporte UEFI.
    mtools: Ferramentas para manipular sistemas de arquivos MS-DOS.
    xorriso: Utilitário para criação de imagens ISO.
    squashfs-tools: Ferramentas para criar o sistema de arquivos SquashFS.

Essas dependências são instaladas automaticamente pelo script.
Como Funciona

    O script instala as dependências necessárias.
    Configura a estrutura de diretórios UEFI e copia os arquivos essenciais (vmlinuz, initrd.img) do sistema atual.
    Cria um sistema de arquivos comprimido SquashFS a partir do diretório root especificado (padrão: /).
    Gera uma ISO UEFI inicializável utilizando grub-mkrescue.

Estrutura do Script

    install_dependencies: Instala as dependências necessárias.
    setup_efi_structure: Configura os arquivos essenciais de inicialização UEFI.
    setup_filesystem: Copia o kernel e initramfs para o diretório de trabalho.
    copy_rootfs: Cria o sistema de arquivos SquashFS a partir do root do sistema.
    create_uefi_iso: Usa grub-mkrescue para gerar a ISO compatível com UEFI.

Como Usar
1. Faça o Download e Torne o Script Executável

bash

chmod +x DragonBuilder.sh

2. Execute o Script como Root

bash

sudo ./DragonBuilder.sh

3. Caminho Personalizado para o Root

O caminho padrão para o sistema de arquivos root é /. Se você deseja criar a ISO a partir de outro diretório (por exemplo, uma montagem de root em /mnt/rootfs), modifique a variável ROOTFS_PATH no script:

bash

ROOTFS_PATH="/mnt/rootfs"

4. Arquivo Gerado

Após a execução bem-sucedida do script, a ISO será gerada no diretório de trabalho especificado (/tmp/iso_build) com o nome custom_linux_uefi.iso.
Problemas Conhecidos

    Tamanho pequeno da ISO: Se o diretório root não estiver configurado corretamente, a ISO pode ser gerada sem o sistema de arquivos completo. Verifique se o caminho root está correto e se o sistema de arquivos está sendo incluído.
    Erro com xattr: Avisos como Unrecognised xattr prefix system.posix_acl_access podem aparecer durante a criação do sistema de arquivos root, mas são inofensivos.

Cancelar o Processo

Se você precisar cancelar o processo de criação da ISO no meio do caminho, o arquivo filesystem.squashfs ficará incompleto. Para tentar novamente, remova os arquivos temporários e reexecute o script:

bash

sudo rm -rf /tmp/iso_build
sudo ./DragonBuilder.sh

Licença

Este script é livre para uso, modificação e distribuição conforme os termos da licença MIT.
