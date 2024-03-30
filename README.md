<h1 align="center">Visuli</h1>

#### Uma solução simples para administradores de sistemas que desejam monitorar seus servidores de forma eficaz, sem a necessidade de compartilhar credenciais de acesso.

## 
### <ins>Funcionalidades</ins>

Atualmente, o Visuli oferece funcionalidades que permitem monitorar e obter dados sobre o estado do servidor. Algumas das principais funcionalidades incluem:

- Memória
- Disco
- Load (Processamento)
- Tamanho dos arquivos de logs
- Informações da distro
- Portas
- Log de usuário

## 
### <ins>Nota</ins>
O Visuli atualmente suporta monitoramento para um único servidor, visando simplicidade e facilidade de uso. Possíveis atualizações futuras podem incluir suporte para múltiplos servidores.

- Exemplo 1:
![2024-03-24_17-21](https://github.com/paulo-hj/Visuli/assets/95994249/35765c23-cffe-4efa-81e9-3c4237790ba2)

- Exemplo 2:
![2024-03-24_17-22](https://github.com/paulo-hj/Visuli/assets/95994249/b6685f58-622c-467a-8760-50df90810c21)

- Exemplo modo responsivo:
  
  ![cel](https://github.com/paulo-hj/Visuli/assets/95994249/ab9c0ad1-0466-4616-b424-133472d7454b)

## 
### <ins>Instalação</ins>

#### 1. Clonar repositório:
```
git clone https://github.com/paulo-hj/Visuli
```

#### 2. Acessar o repositório e dar permissão de execução aos scripts:
```
cd Visuli && chmod +x visuli-conf.sh visuli-main.sh
```

#### 3. Executar script de instalação:
```
sudo ./visuli-conf.sh
```

## 
O Visuli traz um script para facilitar a instalação e alteração das configurações, como, por exemplo, alteração do tempo da rotina no Cron, portas que devem ser verificadas e funcionalidades ativas.

- Exemplos:
![image](https://github.com/paulo-hj/Visuli/assets/95994249/c333622e-6463-47f7-81c2-9a6da0b1f3fa)
![image](https://github.com/paulo-hj/Visuli/assets/95994249/6484e26e-c090-4b30-87b5-f2d02985d7c1)
