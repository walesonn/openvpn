#!/bin/bash
    
# -f comando usado quando se quer adormecer o job
# -D Dynamic ports 
# -p porta ssh
 
ssh -f -D8888 -p55555 $(curl icanhazip.com) sleep 120

# Testar use o comando asseguir certifique-se de ter um servidor rodando na porta 80 se espera receber
# uma resposta
# O cURL usa all_proxy como forma de configurar o proxy SOCKS para sua execução

;all_proxy="socks5://127.0.0.1:8888" curl 127.0.0.1:80

#o comando abaixo é usado ver as requisições

;tcpdump port 8888 -ilo -n