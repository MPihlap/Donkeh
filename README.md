# Donkeh setup

## Aliased ja muu taoline
Lisada järgnevad read `~/.bashrc` lõppu:
```
alias ct="rm -r ~/mycar_new/data/*"
alias j="cd ~/mycar_new && python manage.py drive --js"
alias d="cd ~/mycar && python manage.py drive"
alias donkeyoff="sudo poweroff"
alias c="ssh pi@donkeh2.local"
```

Ja järgmised sama faili lõppu:
```
export PYTHONPATH=/usr/local/lib:/usr/local/lib:/home/pi/donkeycar
source ~/env2/bin/activate
```

## MOTD
Luua fail nimega `/etc/update-motd.d/20-aliases` järgmise sisuga:
```
#!/bin/sh
echo ""
echo "Kasutatavad aliased:"
echo "c - logi teise donkeysse sisse"
echo "j - juhi donkey-t Meelise puldi abil"
echo "donkeyoff - lülita donkeycar välja (Vähemalt raspi osa. Kui tuju on hea paneb see ka gaasi põhja.)"
```

Teha `sudo chmod +x /etc/update-motd.d/20-aliases` ka sellele!
