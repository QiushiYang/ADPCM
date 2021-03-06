# ADPCM
ADPCM Codec:Encoding and Decoding

The ADPCM codec is fully coded by "adpcm.pdf": [Dialogic ADPCM Algorithm](http://www.cs.columbia.edu/~hgs/audio/dvi/IMA_ADPCM.pdf).

By analyzing the process of the ADPCM codec algorithm, especially when the original audio signal is quantized to obtain the binary number "D3-D2-D1-D0" in the encoding process, it can be found that the algorithm in the pdf-document can be expressed directly by the binary number simply. But considering the original pdf-document and easy to understand, the program is basically not simplified by algorithm.

Results
--------
Here shows the figures of the waveform comparison in the time-domain before and after the audio encoding and decoding. <br>
![](https://raw.githubusercontent.com/QiushiYang/ADPCM/master/ADPCM%20Figure.jpg)  
