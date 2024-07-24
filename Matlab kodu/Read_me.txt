Merhabalar,

Aşağıdaki adımları takip ederek bir modelin Monostatik Radar Kesit Alanı hesaplaması yapılabilir.

1- Radar Kesit Alanı hesaplanacak model '.stl' formatında olmalı.
2- MATLAB komut satırına 'rpm' yazın. (rpm: radar cross section with matlab)
3- Açılan pencerede 'Utilities' butonuna tıklayın.
4- Import model yazısının altındaki 'ACIS Solid (*.stl)' butonuna tıklayın ve modeilinizi seçip komut satırına 'y' yazın. modelinizi '.mat' formatında kaydedin.
5- Daha sonra 'CalcRCS' dosyasındaki "% Parametrelerin belirlenmesi" kısmında yer alan hesaplama parametrelerini girin (Sadece 28-34 satırları) ve kaydedin.
6- RCS prediction with MATLAB penceresinde 'Calculate Monostatic RCS' butonuna tıklayın.
7- 'Load file' butonuna tıklayarak 4 numaralı işlemde kaydedilen modeli seçin ve 'close' butonuna basın.
8- 'Calculate RCS' butonuna tıklayarak hesaplamayı başlatın.
9- Sonuçları istenilen formatta kaydedin. Text formatında sonuçlarınızı 724-1084 satırları arasında bulabilirsiniz.
10- '.mat' uzantılı modelinizi de 'export model' butonuyla '.stl'formatına dönüştürebilirsiniz.

İyi çalışmalar.