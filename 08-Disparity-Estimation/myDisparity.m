function D = myDisparity(imgLeft, imgRight, maxDisparity, windowSize, Ver, Auf)
    %1) Punkte im linken Bild im Rechten Bild suchen
    %2) Rektifizierte Bilder: Bildzeilen suchen reicht!!
    %3) Anordnung bekannt: Punkte des linken Bildes können sich nur weiter
    %links im Rechten Bild befinden
    %4) Param maxDisparity beschränkt den Suchraum und legt die
    %kleinstmöglichen detektierbaren Abstand zur Kamera fest.


    % TODO
    Aufgabe = Auf;
    Teil = Ver;

    if Aufgabe == 1 

        filter_kern = [0,0,1];
        D_vals = zeros(size(imgLeft,1),size(imgLeft,2),maxDisparity);
        imgRight_versch = imgRight;
    
        for k = 1:maxDisparity
    
            imgRight_versch = conv2(imgRight_versch,filter_kern,"same");
            D_vals(:,:,k) = abs(imgLeft - imgRight_versch);
            
        end
        
        %D = min(D_vals(:,:,1:maxDisparity));
        [~, D] = min(D_vals, [], 3);
    else
        filter_kern = [0,0,1];
        
        D_vals = zeros(size(imgLeft,1),size(imgLeft,2),maxDisparity);
        imgRight_versch = imgRight;
        %filter_kern_sad = [1, 1, 1;
        %                   1, 1, 1;
        %                   1, 1, 1];
        
        wind_var = windowSize ^2;
        filter_kern_sad = ones(wind_var);
        
            
         for k = 1:maxDisparity

            imgRight_versch = conv2(imgRight_versch,filter_kern,"same");
            
            %SAD
            if Teil == 'SAD'
                diff = abs(imgLeft - imgRight_versch);
                D_vals(:,:,k) = conv2(diff,filter_kern_sad,"same");
             %SSD
            elseif Teil == 'SSD'
                diff = (imgLeft - imgRight_versch).^2;
                D_vals(:,:,k) = conv2(diff,filter_kern_sad,"same");
            %NCC
            else
                mov_mean_right(:,:,k) = movmean(imgRight_versch,[wind_var,wind_var]);
                mov_mean_left(:,:,k) = movmean(imgLeft,[wind_var,wind_var]);
                zah(:,:,k) = (imgLeft-mov_mean_left(:,:,k)).*(imgRight_versch-mov_mean_right(:,:,k));
                nen1(:,:,k) = (imgLeft-mov_mean_left(:,:,k)).^2;
                nen2(:,:,k) = (imgRight_versch-mov_mean_right(:,:,k)).^2;
                convnen1(:,:,k) = conv2(nen1(:,:,k),filter_kern_sad,"same");
                convnen2(:,:,k) = conv2(nen2(:,:,k),filter_kern_sad,"same");
                convzah(:,:,k) = conv2(zah(:,:,k),filter_kern_sad,"same");
                allzah(:,:,k) = convzah(:,:,k).^2;
                allnen(:,:,k) = convnen1(:,:,k).*convnen2(:,:,k);
                D_vals(:,:,k) = 1-(allzah(:,:,k)./allnen(:,:,k));
            end
        
         end
        
    
            % for k = 1:maxDisparity
            % 
            %     %imgRight_versch = conv2(imgRight_versch,filter_kern,"same");
            %     for y = 1:size(imgLeft,2)
            %         for x = 1:size(imgLeft,1)
            %             win_I_left = window3(imgLeft,y,x);
            %             win_I_right = window3(imgRight,y,x+k);
            %             %D_vals(y,x,k) = SAD(win_I_left,win_I_right);
            %         end
            %     end
            % end
        

        [~, D] = min(D_vals, [], 3);


end