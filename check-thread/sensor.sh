
#Для работы с изображениями
#должна быть установлена программа ImageMagick
#apt-get install ImageMagick

# Отключаем вывод курсора на экран
setterm -cursor off


# Назначаем переменные

#--
#Границы участка анализа, image2
#ширина=15 высота=15
x21=110
y21=60
x22=125
y22=75

#--

#Создаем переменные для значений стандартного отклонения яркости
stdev2=0

#Переменные для проверки цифр в позициях 3 в stdev
#чтобы узнать, перекрыт ли свет от красного светодиода (при установке детали)
#там первый знак ноль, второй знак точка
#если третий знак >0, значит деталь НЕ УСТАНОВЛЕНА (видно красный светодиод)

#Чтобы начать цикл по проверке, ставим значение 1
pos3=1


# Делаем цикл по проверке, установлена ли деталь
# Квадратные скобки ставим двойные, иначе ошибки появляются
while [[ $pos3 -gt 0 ]]; do

clear
sleep 0.2
echo -e "\n"
echo " Установите деталь"
echo -e "\n"

# Фотографирование, вывод ошибок - в /dev/null
fswebcam -d /dev/video2 ./image/image2.jpg 2> /dev/null

#Увеличиваем контрастность изображения
convert ./image/image2.jpg -level 0,15000,0,87 ./image/image2.jpg

#Вычисляем стандартное отклонение яркости
# на участке WidthxHeight+left+top
# Направляем stdev в текстовый файл
convert ./image/image2.jpg -crop 15x15+$x21+$y21 -format "%[fx:standard_deviation]" info: >./image/imagestdev2.txt

# Извлекаем значения стандартного отклонения из текстового файла в переменные
# и наносим на фотографии
read stdev2 < ./image/imagestdev2.txt
convert ./image/image2.jpg -fill white -pointsize 15 -annotate +20+20 "(2) stdev: $stdev2" ./image/image2.jpg

# Проверяем значение третьего знака


cut -c 3 ./image/imagestdev2.txt > ./image/pos3.txt
read pos3 < ./image/pos3.txt
#echo $pos3


done
	
clear
echo -e "\n"
echo " Деталь установлена"
echo -e "\n"
		

#--


#Рисуется прямоугольник на фотографии
# пример: convert input.jpg -fill red -draw 'rectangle x1,y1 x2,y2' output.png.
convert ./image/image2.jpg -fill none -stroke red -draw "rectangle $x21,$y21 $x22,$y22" ./image/image2.jpg

