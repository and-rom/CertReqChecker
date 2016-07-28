#!/bin/bash
msg1="Введите путь к папке-письму: "
msg2="Обрабатывются запросы..."
msg3="Запуск python скрипта"
msg4="Завершение"

batpath=$(dirname $0)

  if [ "$1" == "" ];then
    read -r -p "$msg1" runpath
  else
    runpath=$1
  fi

  if [ ! -d $runpath/asn ];then
    mkdir $runpath/asn
  fi

  echo $msg2

	for file in $runpath/req/*/*
	do
		file_name=${file##*/}
		file_name=${file_name%%.*}

		if [ ! -f $runpath/asn/$file_name.txt ];then
      dumpasn1 -p $file | sed "s/OBJECT IDENTIFIER '/OBJECT IDENTIFIER unknown (/g;s/'$/)/g" | sed ':l /OBJECT IDENTIFIER/s/\(([^ )]*\)[ ]/\1./;tl' > $runpath/asn/$file_name.txt
		else
			echo "Уже проверено"
		fi
	done

  echo $msg3
  echo "python $batpath/check.py $runpath"

  echo $msg4

