 function [x1F,y1F,x1C,y1C,x2F,y2F,x2C,y2C] = UDPparaCamara()
  u = udp('220.1.1.3',4667,'LocalPort',4666);
  robot=1;
  
        sprintf('Tomando posicion de la camara')
        try 
            fopen(u); %Se abre comunicacion para la camara.
        catch
            sprintf('No abrio canal de comunicacion con camaras');
            %break;
        end
        
       sprintf('Conectado');
        
       
       % while(1)
       try
           sprintf('Leyendo');
            A = fread(u,11); %Leemos las posiciones que nos llega de la camara.
            sprintf(A)
            fclose(u)
%             sprintf('Lei en el buffer');
       catch
           sprintf('No se recibio ningun paquete');
           fclose(u)
           %break;
       end
       sprintf('Cerrando conexion'); 
       fclose(u);
       try    
           sprintf('Lo recibido es:');
           message=char(A);%Se cambia de formato para su parseo
       catch
           sprintf('Formato desconocido, no se pudo cambiar de formato');
           %break;
       end
    %         sprintf('%s\n',B(:));
    %         message=B
    %         message='f123,132;c123,123';

    %         message='f1,22;c333,4444;';
        sprintf('%c',A);
        sprintf('%d',length(message));
        count(1,1)=0;
        try %Parseo
            
            for i=1:1:length(message)
                if message(i)=='i'
                    if message(i+2)=='1'
                        id=0;%ahora count tiene cuatro columnas f y c del robot 1 y f y c del robot 2
                    else
                        id=1;
                    end                
                elseif message(i)=='f'
                    j=i;
                    count(1,1+2*id) = j+1;
                    while message(j)~=';'
                        if message(j)==','
                            count(2,1+2*id)=j-1;
                            count(3,1+2*id)=j+1;
                        end
                        j=j+1;
                    end    
                   count(4,1+2*id)=j-1;

                elseif message(i)=='c'
                    j=i;
                    count(1,2+2*id) = j+1;
                    while(message(j)~=';')
                        if message(j)==','
                            count(2,2+2*id)=j-1;
                            count(3,2+2*id)=j+1;
                        end
                        j=j+1;
                    end    
                   count(4,2+2*id)=j-1;
                end
            end
            
            posicion1fx=message(count(1,1):count(2,1));
            posicion1fy=message(count(3,1):count(4,1));

            posicion1cx=message(count(1,2):count(2,2));
            posicion1cy=message(count(3,2):count(4,2));
            
            posicion2fx=message(count(1,3):count(2,3));
            posicion2fy=message(count(3,3):count(4,3));

            posicion2cx=message(count(1,4):count(2,4));
            posicion2cy=message(count(3,4):count(4,4));
           
            sprintf('Robot1');
            x1F=str2num(sprintf('%c',posicion1fx))*0.00267;
            y1F=str2num(sprintf('%c',posicion1fy))*0.00267;
            x1C=str2num(sprintf('%c',posicion1cx))*0.00267;
            y1C=str2num(sprintf('%c',posicion1cy))*0.00267;
            
            sprintf('Robot2');
            x2F=str2num(sprintf('%c',posicion2fx))*0.00267;
            y2F=str2num(sprintf('%c',posicion2fy))*0.00267;
            x2C=str2num(sprintf('%c',posicion2cx))*0.00267;
            y2C=str2num(sprintf('%c',posicion2cy))*0.00267;
            
            
%             plot(x1F,y1F);
%             plot(x1C,y1C);
%             plot(x2F,y2F);
%             plot(x2C,y2C);
            
            sprintf('Llego al fin');
            
        catch
            sprintf('Problema en el parseo');
%             break;
        end
    %end
  end
 