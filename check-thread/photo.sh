
#Для работы с изображениями
#должна быть установлена программа ImageMagick
#apt-get install ImageMagick

# Организуем вечный цикл
while true
do

# Проверяем, установлена ли деталь
bash sensor.sh


# Назначаем переменные

#--
#Границы участка анализа, image2
#(2) ширина=75 высота=15
x21=150
y21=60
x22=225
y22=75

#--

#Границы участка анализа, image4
#(4) ширина=105 высота=30
x41=100
y41=75
x42=205
y42=105

#--

#Границы участка анализа, image6
#(6) ширина=80 высота=15
x61=100
y61=100
x62=180
y62=115

#--

#Границы участка анализа, image8
#(8) ширина=65 высота=20
x81=120
y81=50
x82=185
y82=70

#Создаем переменные для значений стандартного отклонения яркости
stdev2=0
stdev4=0
stdev6=0
stdev8=0

#Переменные для проверки цифр в позициях 3 и 4, в stdev
#чтобы узнать, где резьба, перегородка, отверстие
#там первый знак ноль, второй знак точка
#если третий знак >0, значит Резьба
#если третий знак =0 И четвертый знак >0, значит перегородка
#если третий знак =0 И четвертый знак =0, значит отверстие
pos3=0
pos4=0

# Фотографирование, вывод ошибок - в /dev/null
fswebcam -d /dev/video2 ./image/image2.jpg 2> /dev/null
fswebcam -d /dev/video4 ./image/image4.jpg 2> /dev/null
fswebcam -d /dev/video6 ./image/image6.jpg 2> /dev/null
fswebcam -d /dev/video8 ./image/image8.jpg 2> /dev/null

#Увеличиваем контрастность изображения
convert ./image/image2.jpg -level 0,15000,0,87 ./image/image2.jpg
convert ./image/image4.jpg -level 0,15000,0,87 ./image/image4.jpg
convert ./image/image6.jpg -level 0,15000,0,87 ./image/image6.jpg
convert ./image/image8.jpg -level 0,15000,0,87 ./image/image8.jpg

#Вычисляем стандартное отклонение яркости, записываем в текстовые файлы
# WidthxHeight+left+top
#convert ./image/image2.jpg -crop 30x23+150+57 -format "%[fx:standard_deviation]" info: >./image/imagestdev2.txt
#convert ./image/image4.jpg -crop 30x30+175+75 -format "%[fx:standard_deviation]" info: >./image/imagestdev4.txt
#convert ./image/image6.jpg -crop 60x10+120+110 -format "%[fx:standard_deviation]" info: >./image/imagestdev6.txt
#convert ./image/image8.jpg -crop 30x30+120+50 -format "%[fx:standard_deviation]" info: >./image/imagestdev8.txt

# Направляем stdev в текстовый файл
convert ./image/image2.jpg -crop 75x15+$x21+$y21 -format "%[fx:standard_deviation]" info: >./image/imagestdev2.txt
convert ./image/image4.jpg -crop 105x30+$x41+$y41 -format "%[fx:standard_deviation]" info: >./image/imagestdev4.txt
convert ./image/image6.jpg -crop 80x15+$x61+$y61 -format "%[fx:standard_deviation]" info: >./image/imagestdev6.txt
convert ./image/image8.jpg -crop 65x20+$x81+$y81 -format "%[fx:standard_deviation]" info: >./image/imagestdev8.txt

# Извлекаем значения стандартного отклонения из текстового файла в переменные
# и наносим на фотографии
read stdev2 < ./image/imagestdev2.txt
read stdev4 < ./image/imagestdev4.txt
read stdev6 < ./image/imagestdev6.txt
read stdev8 < ./image/imagestdev8.txt
convert ./image/image2.jpg -fill white -pointsize 15 -annotate +20+20 "(2) stdev: $stdev2" ./image/image2.jpg
convert ./image/image4.jpg -fill white -pointsize 15 -annotate +20+20 "(4) stdev: $stdev4" ./image/image4.jpg
convert ./image/image6.jpg -fill white -pointsize 15 -annotate +20+20 "(6) stdev: $stdev6" ./image/image6.jpg
convert ./image/image8.jpg -fill white -pointsize 15 -annotate +20+20 "(8) stdev: $stdev8" ./image/image8.jpg

# Проверяем значение третьего и четвертого знака в stdev
# в зависимости от результата делаем вывод:
# резьба, или перегородка, или отверстие

pos3=0
pos4=0

cut -c 3 ./image/imagestdev2.txt > ./image/pos3.txt
read pos3 < ./image/pos3.txt
#echo $pos3

cut -c 4 ./image/imagestdev2.txt > ./image/pos4.txt
read pos4 < ./image/pos4.txt
#echo $pos4

# Квадратные скобки ставим двойные, иначе ошибки появляются

if [[ $pos3 -gt 0 ]]; then
  echo "(2) резьба"
else
	if [[ $pos4 -gt 0 ]]; then
	echo "(2) перегородка"
		else
		echo "(2) отверстие"
		fi
fi

#--

pos3=0
pos4=0

cut -c 3 ./image/imagestdev4.txt > ./image/pos3.txt
read pos3 < ./image/pos3.txt
#echo $pos3

cut -c 4 ./image/imagestdev4.txt > ./image/pos4.txt
read pos4 < ./image/pos4.txt
#echo $pos4

if [[ $pos3 -gt 0 ]]; then
  echo "(4) резьба"
else
	if [[ $pos4 -gt 0 ]]; then
	echo "(4) перегородка"

		else
		echo "(4) отверстие"
		fi
fi


#--

pos3=0
pos4=0

cut -c 3 ./image/imagestdev6.txt > ./image/pos3.txt
read pos3 < ./image/pos3.txt
#echo $pos3

cut -c 4 ./image/imagestdev6.txt > ./image/pos4.txt
read pos4 < ./image/pos4.txt
#echo $pos4

if [[ $pos3 -gt 0 ]]; then
  echo "(6) резьба"
else
	if [[ $pos4 -gt 0 ]]; then
	echo "(6) перегородка"
		else
		echo "(6) отверстие"
		fi
fi

#--
pos3=0
pos4=0

cut -c 3 ./image/imagestdev8.txt > ./image/pos3.txt
read pos3 < ./image/pos3.txt
#echo $pos3

cut -c 4 ./image/imagestdev8.txt > ./image/pos4.txt
read pos4 < ./image/pos4.txt
#echo $pos4

if [[ $pos3 -gt 0 ]]; then
  echo "(8) резьба"
else
	if [[ $pos4 -gt 0 ]]; then
	echo "(8) перегородка"
		else
		echo "(8) отверстие"
		fi
fi

#--

# Добавим результаты в лог
cat ./image/imagestdev2.txt >> log.txt
echo -e "\r" >> log.txt
cat ./image/imagestdev4.txt >> log.txt
echo -e "\r" >> log.txt
cat ./image/imagestdev6.txt >> log.txt
echo -e "\r" >> log.txt
cat ./image/imagestdev8.txt >> log.txt
echo -e "\n" >> log.txt


#Рисуется прямоугольник на фотографии
# пример: convert input.jpg -fill red -draw 'rectangle x1,y1 x2,y2' output.png.
convert ./image/image2.jpg -fill none -stroke red -draw "rectangle $x21,$y21 $x22,$y22" ./image/image2.jpg
convert ./image/image4.jpg -fill none -stroke red -draw "rectangle $x41,$y41 $x42,$y42" ./image/image4.jpg
convert ./image/image6.jpg -fill none -stroke red -draw "rectangle $x61,$y61 $x62,$y62" ./image/image6.jpg
convert ./image/image8.jpg -fill none -stroke red -draw "rectangle $x81,$y81 $x82,$y82" ./image/image8.jpg

# Каталог image копируется в archive, присваивается имя YYYYMMDDhhmmss
cp -r ./image ./archive/$(date "+%Y%m%d_%H%M%S")

sleep 10

done

# --------------------------

# Ниже информация, которая может быть полезна

#определить среднюю яркость изображения
#convert ./image/image2.jpg -colorspace gray -scale 1x1! -format "%[pixel:p{0,0}]" info: > ./image/image2color.txt
#convert ./image/image4.jpg -colorspace gray -scale 1x1! -format "%[pixel:p{0,0}]" info: > ./image/image4color.txt
#convert ./image/image6.jpg -colorspace gray -scale 1x1! -format "%[pixel:p{0,0}]" info: > ./image/image6color.txt
#convert ./image/image8.jpg -colorspace gray -scale 1x1! -format "%[pixel:p{0,0}]" info: > ./image/image8color.txt

#эта команда показывает картинку
#при этом программа виснет
#если картинку закрыть, продолжает работу
#display ./image/image2.jpg

# Руководство ImageMagick
# https://pda.coollib.cc/b/558566-ivan-georgievich-titarenko-rukovodstvo-polzovatelya-imagemagick-v-710/read#SEC_23
