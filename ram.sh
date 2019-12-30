#!/bin/bash
## Önbelleğe alınmış belleği temizlemek için Bash Script
## Tactically
## <https://twitter.com/habib_karatas>

if [ "$(whoami)" != "root" ]
then
  echo "Bu scripti ROOT olarak çalıştırmalısınız!"
  exit 1
fi

# Bellek Bilgilerini Alın
eski_bos_ram=$(cat /proc/meminfo | grep MemFree | tr -s ' ' | cut -d ' ' -f2) && eski_bos_ram=$(echo "$eski_bos_ram/1024.0" | bc)
eski_onbellek=$(cat /proc/meminfo | grep "^Cached" | tr -s ' ' | cut -d ' ' -f2) && eski_onbellek=$(echo "$eski_onbellek/1024.0" | bc)

# Çıktı Bilgisi
echo -e "Bu komut dosyası önbelleğe alınmış belleği temizler ve RAM'inizi boşaltır.\n\nKullanılan Önbellek= $eski_onbellek MB
\nKullanılan RAM= $eski_bos_ram MB\n"

# Senkronizasyon Testi
if [ "$?" != "0" ]
then
  echo "Sanırım bir şeyler ters gitti, dosya sistemi senkronize edilemiyor."
  exit 1
fi

# "Sync" kullanarak Önbellekleri Temizle
sync && echo 3 > /proc/sys/vm/drop_caches

yeni_bos_ram=$(cat /proc/meminfo | grep MemFree | tr -s ' ' | cut -d ' ' -f2) && yeni_bos_ram=$(echo "$yeni_bos_ram/1024.0" | bc)

# Özet
echo -e "Temizlenen RAM=$(echo "$yeni_bos_ram - $eski_bos_ram" | bc) MB\n\nKullanılabilir RAM=$yeni_bos_ram "

exit 0
