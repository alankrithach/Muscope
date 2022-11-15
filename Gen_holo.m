%%%%%%%%%%%%%%%%%%%%%
% Alankritha: 
%This code is used to generate inline hologram with plane waves 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMULATION OF IN-LINE HOLOGRAM WITH PLANE WAVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Citation for this code/algorithm or any of its parts:
% Tatiana Latychevskaia and Hans-Werner Fink
% "Solution to the Twin Image Problem in Holography",
% Physical Review Letters 98, 233901 (2007)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The code is written by Tatiana Latychevskaia, 2007
% Matlab version for this code is R2010b
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  clear all
  close all
% addpath('C:/Program Files/MATLAB/R2010b/myfiles');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parameters
  N = 500;                    % number of pixels
  lambda = 532*10^(-9);       % wavelength in meter
  object_area = 0.002;        % object area sidelength in meter
  z = 0.05;                   % object-to-detector distance in meter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reading object distribution
  object = zeros(N,N);        
    object0 = imread('a_hair.jpg');  
    object(:,:) = rot90(rot90(rot90(object0(:,:,1))));   
    object = (object - min(min(object)))/(max(max(object)) - min(min(object)));  
% showing object distribution
    figure, imshow(flipud(rot90(object)), []);
    title('object distribution / a.u.')
    xlabel({'x / px'})
    ylabel({'y / px'})
    axis on
    set(gca,'YDir','normal')
    colormap('gray')
    colorbar;  
% creating object plane transmission function
  am = exp(-1.6*object);    % exp(-1.6)=0.2
  ph = - 3*object;
  t = zeros(N,N);
  t = am.*exp(i*ph);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulating hologram
  prop = Propagator(N, lambda, object_area, z);
  U = IFT2Dc(FT2Dc(t).*conj(prop));
  hologram = abs(U).^2;
% showing simulated hologram
    figure, imshow(flipud(rot90(hologram)), []);
    title('simulated hologram / a.u.')
    xlabel({'x / px'})
    ylabel({'y / px'})
    axis on
    set(gca,'YDir','normal')
    colormap('gray')
    colorbar; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% saving simulated hologram as BIN file
  fid = fopen(strcat('a_hologram.bin'), 'w');
  fwrite(fid, hologram, 'real*4');
  fclose(fid);
% saving simulated hologram as JPG file
  p = rot90(hologram);
  p = 255*(p - min(min(p)))/(max(max(p)) - min(min(p)));
  imwrite (p, gray, 'a_hologram.jpg');
