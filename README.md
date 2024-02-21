### Docker Compose File Structure

Il file `docker-compose.yml` sarà strutturato come segue:

yamlCopy code

`version: '3.8'  services:   wireguard:     image: linuxserver/wireguard     ports:       - "51820:51820/udp"     volumes:       - "./volumes/wireguard:/config"       - "/lib/modules:/lib/modules"     environment:       - PUID=1000       - PGID=1000     cap_add:       - NET_ADMIN       - SYS_MODULE     sysctls:       - net.ipv4.conf.all.src_valid_mark=1     networks:       private_network:         ipv4_address: 10.5.0.2    wireguard-ui:     image: embarkstudios/wireguard-ui     depends_on:       - wireguard     volumes:       - "./volumes/wireguard-ui:/data"     environment:       - WG_CONF_DIR=/data/conf     networks:       private_network:         ipv4_address: 10.5.0.3    lazydocker:     image: lazyteam/lazydocker     volumes:       - "/var/run/docker.sock:/var/run/docker.sock"       - "./volumes/lazydocker:/root/.config/lazydocker"     networks:       private_network:         ipv4_address: 10.5.0.4    code-server:     image: codercom/code-server:latest     volumes:       - "./volumes/code-server:/home/coder/project"     environment:       - PASSWORD=your-password-here # Change this     networks:       private_network:         ipv4_address: 10.5.0.5    gitea:     image: gitea/gitea:latest     volumes:       - "./volumes/gitea:/data"     networks:       private_network:         ipv4_address: 10.5.0.6    netdata:     image: netdata/netdata     volumes:       - "/proc:/host/proc:ro"       - "/sys:/host/sys:ro"       - "/var/run/docker.sock:/var/run/docker.sock:ro"       - "./volumes/netdata:/var/cache/netdata"     networks:       private_network:         ipv4_address: 10.5.0.7    homer:     image: b4bz/homer     volumes:       - "./volumes/homer:/www/assets"     networks:       private_network:         ipv4_address: 10.5.0.8    coredns:     image: coredns/coredns     volumes:       - "./volumes/coredns:/root"     command: -conf /root/Corefile     networks:       private_network:         ipv4_address: 10.5.0.9  networks:   private_network:     ipam:       config:         - subnet: 10.5.0.0/24  volumes:   wireguard:   wireguard-ui:   lazydocker:   code-server:   gitea:   netdata:   homer:   coredns:`

### CoreDNS Configuration

Per `coredns`, dovrai creare un file `Corefile` nella directory `./volumes/coredns` con il seguente contenuto, sostituendo `<nome-servizio>` con i nomi dei servizi appropriati e `10.5.0.x` con gli indirizzi IP statici assegnati:

confCopy code

`.:53 {     hosts {         10.5.0.2 wireguard         10.5.0.3 wireguard-ui         10.5.0.4 lazydocker         10.5.0.5 code-server         10.5.0.6 gitea         10.5.0.7 netdata         10.5.0.8 homer         10.5.0.9 coredns     }     forward . 8.8.8.8     log     errors }`

### File `.env_minimal`

Crea un file `.env_minimal` nella stessa directory del file `docker-compose.yml` e definisci tutte le variabili di ambiente richieste dai container. Ad esempio:

dotenvCopy code

`PUID=1000 PGID=1000 PASSWORD=your-password-here # Sostituisci con la tua password`

### Note

*   Assicurati di sostituire `your-password-here` con una password sicura per `code-server`.
*   Puoi aggiungere o modificare variabili d'ambiente nel file `.env_minimal` a seconda delle esigenze specifiche di ogni container.
*   Verifica la documentazione specifica di ogni immagine del container per eventuali requisiti o variabili d'ambiente aggiuntive.
*   Dopo aver configurato tutto, puoi avviare l'ambiente con `docker-compose up -d`.
*   

### TODO

'''
Distruggere questo schifo e passare subbito alla versione alpha 0.2 con i file per le variabili di ambiente. (ma almeno l'idea c'è)
'''