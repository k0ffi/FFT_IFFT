close all;





image = imread("cristiano.jpg") ; 

figure('Name','image de base') ; 

imshow(image) ;

if size(image, 3) == 3
    image = rgb2gray(image);
end




% verification du TFD 1D

G = [45 156 222 1];
Four1 = fft_1D(G)
Inv1 = abs(ifft_1D(Four1)/4) % on divise par N car la normalisation de fait dans la fft_2D 

%verification du TFD 2D sans image

I = [124 223 34 67;
    45 56 76 222;
    45 58 244 222;
    45 56 76 222;
    45 56 76 222;
    45 56 76 222;
    45 56 76 222;
    45 56 76 222];
Four2 = fft_2D(I)
Inv2 = abs(ifft_2D(Four2))


%verification du TFD 2D  avec image 

F =fft_2D(image);
figure('Name','Transformé de fourrier rapide');
imshow(F);

restored_image  =ifft_2D(F) ; 
figure('Name','Transformé de fourrier inverse') ; 
imshow(uint8(restored_image)) ; 





function result = fft_1D(signal)
    N = length(signal);
    if N == 1
        %cas de base
        result = signal; 
    else
        signal_paire = signal(1:2:N);
        signal_impaire = signal(2:2:N);
        fft_paire= fft_1D(signal_paire);
        fft_impaire = fft_1D(signal_impaire);
        
        result = zeros(1, N);
        for k = 1:N/2
            % Facteur de pondération complexe
            facteur = exp(-2i * pi * (k-1) / N); 
            result(k ) = fft_paire(k) + facteur * fft_impaire(k );
            result(k + N/2 ) = fft_paire(k ) - facteur * fft_impaire(k );
        end
    end
end


function result = fft_2D(image)
    image = double(image) / 255.0;
    [M, N] = size(image);
      % Appliquer la FFT sur les lignes
        fft_rows = zeros(M, N);
        for i = 1:M
            fft_rows(i, :) = fft_1D(image(i, :));
        end
        
        % Appliquer la FFT sur les colonnes
        fft_cols = zeros(M, N);
        for j = 1:N
            fft_cols(:, j) = fft_1D(fft_rows(:, j));
        end
        
        result = fft_cols;
        result = double(result) * 255.0;
end

function result = ifft_1D(signal)
    N = length(signal);
    if N == 1
        %cas de base
        result = signal; 
    else
        signal_paire = signal(1:2:N);
        signal_impaire = signal(2:2:N);
        fft_paire= ifft_1D(signal_paire);
        fft_impaire = ifft_1D(signal_impaire);
        
        result = zeros(1, N);
        for k = 1:N/2
            % Facteur de pondération complexe
            facteur = exp(2i * pi * (k-1) / N); 
            result(k ) = fft_paire(k) + facteur * fft_impaire(k );
            result(k + N/2 ) = fft_paire(k ) - facteur * fft_impaire(k );
        end
    end
end


function result = ifft_2D(image)
    [M, N] = size(image);
     % Appliquer la FFT sur les lignes
        fft_rows = zeros(M, N);
        for i = 1:M
            fft_rows(i, :) = ifft_1D(image(i, :))/M;
        end
        
        % Appliquer la FFT sur les colonnes
        fft_cols = zeros(M, N);
        for j = 1:N
            fft_cols(:, j) = ifft_1D(fft_rows(:, j))/N;
        end
        
        result = fft_cols;
end

