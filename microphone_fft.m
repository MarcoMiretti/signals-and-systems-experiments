#!/usr/bin/octave
sampling_frequency_hz = 44100
refresh_rate_hz = 50
refresh_period_s = 1 / refresh_rate_hz
samples_per_acquisition = sampling_frequency_hz * refresh_period_s

seconds_recording = 60
recording_iterations = seconds_recording * refresh_rate_hz;

## About the frequency array to be generated in each sample
# the array has "samples_per_acquisition" size, this values is equivalent
# to a frequency of "sampling_frequency_hz".

# therefore, in said array sample "n" represents a frequency of:
#
#                  sampling_frequency_hz * n
#           f_Hz = -------------------------
#                   samples_per_acquisition

frequency_limit_top_hz = 6000;
top_limit_sample = floor (frequency_limit_top_hz * 
                          (samples_per_acquisition / sampling_frequency_hz));
frequency_array = linspace (0, sampling_frequency_hz, samples_per_acquisition);


figure (1)
axis ([0, frequency_limit_top_hz, 0, samples_per_acquisition / 10])
hold on

recorder = audiorecorder (sampling_frequency_hz, 32);

for i = 1:recording_iterations
  
  
  recordblocking (recorder, refresh_period_s);
  
  if isrecording (recorder)
    stop (recorder);
  endif
  
  data = getaudiodata (recorder);
  fft_data = fft (data);
  cla
  plot ( 
    frequency_array(1:top_limit_sample),
    abs (
      fft_data(1:top_limit_sample)
    )
  )
  refresh ()
endfor
