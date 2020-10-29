## Cargamos el archivo de audio.
[vuvuzela_samples, fs] = audioread ('inputs/bebe.flac');

## Sabemos que fs es la frecuencia de muestreo, por lo que su período:
sampling_period_s = 1/fs;
sample_number = length (vuvuzela_samples);
vuvuzela_duration_s = sample_number * sampling_period_s 

## Creamos un array que represente el tiempo
time_array = linspace (0, vuvuzela_duration_s, sample_number);

## Visualizamos la señal
i = 1
figure (i);
plot (time_array, vuvuzela_samples)
axis ("tight")
xlabel ("time [s]")
ylabel ("amplitude")

vuvuzela_frequency_domain = fft (vuvuzela_samples);
frequency_array = linspace (0, 48000, sample_number);

frequency_limit_top_hz = 6000;
top_limit_sample = floor (sample_number * (frequency_limit_top_hz / fs))
i = i + 1
figure (i);
plot (
  frequency_array(1:top_limit_sample),
  abs (vuvuzela_frequency_domain(1:top_limit_sample))
)
axis ("tight")
xlabel ("frequency [Hz]")
ylabel ("amplitude")

number_of_filters = 2;
order_of_filters = 100;

## vuvuzela
#filter_object_1 = fir1 (order_of_filters, [180 260] * 2 / fs, "stop");
#filter_object_2 = fir1 (order_of_filters, [380 580] * 2 / fs, "stop");
#filter_object_3 = fir1 (order_of_filters, [580 780] * 2 / fs, "stop");
#filter_object_4 = fir1 (order_of_filters, [850] * 2 / fs, "low");

#filter_objects = [
#  filter_object_1,
#  filter_object_2,
#  filter_object_3,
#  filter_object_4
#];

## bebe
filter_object_1 = fir1 (order_of_filters, [850] * 2 / fs, "low");
filter_objects = [
  filter_object_1
];


temp_samples = vuvuzela_samples;
for filter_object = filter_objects'
  i = i + 1
  figure (i)
  freqz (filter_object)
  filtered_vuvuzela = filter (filter_object, 1, temp_samples);
  temp_samples = filtered_vuvuzela;
  vuvuzela_filtered_frequency_domain = fft (temp_samples);
  i = i + 1
  figure (i);
  plot (
    frequency_array(1:top_limit_sample),
    abs (vuvuzela_filtered_frequency_domain(1:top_limit_sample))
  )
endfor
axis ("tight")
xlabel ("frequency [Hz]")
ylabel ("amplitude")

## Escribir el resultado como audio
audiowrite ("data/bebe_filtado.flac", filtered_vuvuzela, fs)
