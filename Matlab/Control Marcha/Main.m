function main( )
    
    R1ON=1
    R2ON=1
    RadioCirculo=0.35;
    toleranciaAlError=0.025;
    try
        if(R1ON==1)
        r1=Bluetooth('Robot1',1);
        fopen(r1);
        end
        if(R2ON==1)
        r2=Bluetooth('Robot2',1);
        fopen(r2);
        end
    catch
            
        sprintf('Problema en comunicacion BT')
    
    end
    
    sprintf('Inicio')
     
    try 
        iteradorTrayectoria=iteradorTrayectoria+1;
    catch
        iteradorTrayectoria=0;
    end

    trayectoriaNueva=circulo(RadioCirculo,0,0,iteradorTrayectoria);
    derivTrayectoria=(trayectoriaNueva-trayectoria)/0.250;
    trayectoria=trayectoriaNueva;

    z1d=[0;0]
    z2d=[0;0.3]

    while true

        try
%             try
%                 zAnterior=[x1F;y1F;x1C;y1C;x2F;y2F;x2C;y2C];
%             catch
%                 zAnterior=zeros(8,1);
%             end
%                             
            [y1F,x1F,y1C,x1C,y2F,x2F,y2C,x2C]=UDPparaCamara();
             
%             for i=1:1:8
%                 Desplazamiento1f=norm(zAnterior(1:2)-[y1F;x1F]);
%                 Desplazamiento1c=norm(zAnterior(3:4)-[y1C;x1C]);
%                 Desplazamiento2f=norm(zAnterior(5:6)-[y2F;x2F]);
%                 Desplazamiento2c=norm(zAnterior(7:8)-[y2C;x2C]);
%             end
%             
%             if(Desplazamiento1f<0.01&&Desplazamiento1c<0.01&&Desplazamiento2f<0.01&&Desplazamiento2c<0.01)
%                 fclose(r1);
%                 fclose(r2);
%                 break;
%             end
            
            sprintf('Robot1');
            x1F
            y1F
            x1C
            y1C
            
            sprintf('Robot2');
            x2F
            y2F
            x2C
            y2C
            
%             x1F=0;
%             y1F=0;
%             x1C=0;
%             y1C=0.1;
%             x2F=0.2;
%             y2F=0;
%             x2C=0.2;
%             y2C=0.1;
        catch
            sprintf('Problema en recepcion de posicion')
            
        end

        try 
            try 
                dientes=dientes+1;
            catch
                dientes=0;
            end
            [omega,dientes,error] = controlFormacionExp( [x1C;y1C],[x1F;y1F],[x2C;y2C],[x2F;y2F], dientes, trayectoria, derivTrayectoria);
        catch 
            sprintf('En el control')
        
        end
        
        omegar1=omega(1:2);
        omegar2=omega(3:4);
        
        disp('Omega1')
        disp(omegar1)
        disp('Omega2')
        disp(omegar2)
        
        wr1max=3.6;
        
        wr2max=5.067;
        
          
        
%         for rueda=1:1:2
%             if wr1max<omegar1(rueda)
%                 omegar1(rueda)=wr1max;
%             elseif -wr1min<omegar1(rueda)&&omegar1(rueda)<wr1min
%                 if 0<omegar1(rueda)
%                     omegar1(rueda)=omegar1(rueda);
%                 else
%                     omegar1(rueda)=omegar1(rueda);
%                 end
%             elseif omegar1(rueda)<-wr1max
%                 omegar1(rueda)=-wr1max;
%             end
%         end
        %%------Nuevo calculo
        pwmr1maxR1Adelante=80;%Rueda izquierda
        pwmr1maxR2Adelante=79;%Rueda izquierda
        pwmr1maxR1Atras=80;
        pwmr1maxR2Atras=90;
        
        %Rueda 1
            rueda=1;
            if omegar1(rueda)>wr1max
                PWMr1(1)=0;
                PWMr1(2)=pwmr1maxR1Adelante;
%                 PWMr1(rueda)=pwmr1maxR1;
            elseif omegar1(rueda)>0
                PWMr1(1)=0;
                PWMr1(2)=abs(8.3*omegar1(rueda)+50);
%                 PWMr1(rueda)=11.1*omegar1(rueda)+40;
            elseif omegar1(rueda)<-wr1max
                PWMr1(1)=abs(pwmr1maxR1Atras);
                PWMr1(2)=0;
%                 PWMr1(rueda)=-pwmr1max;
            elseif omegar1(rueda)<0;
                PWMr1(1)=abs(9.7*omegar1(rueda)-45);
                PWMr1(2)=0;
%                 PWMr1(rueda)=12.5*omegar1(rueda)-35;
            elseif omegar1(rueda)==0
%                 omegar1(rueda)=0;
                PWMr1(2)=0;
                PWMr1(1)=0;
            end
            %Rueda dos
            rueda=2;
            if omegar1(rueda)>wr1max
                PWMr1(3)=pwmr1maxR2Adelante;
                PWMr1(4)=0;
            elseif omegar1(rueda)>0
                PWMr1(3)=8.3*omegar1(rueda)+49;
                PWMr1(4)=0;
            elseif omegar1(rueda)==0
                PWMr1(3)=0;
                PWMr1(4)=0;
            elseif omegar1(rueda)<-wr1max
                PWMr1(3)=0;
                PWMr1(4)=abs(pwmr1maxR2Atras);
            elseif omegar1(rueda)<0;
                PWMr1(3)=0;
                PWMr1(4)=abs(9.7*omegar1(rueda)-55);
            end

        pwmr2max=145;
        for rueda=1:1:2
            
            if omegar2(rueda)>wr2max
                PWMr2(rueda)=pwmr2max;
            elseif omegar2(rueda)>0
                PWMr2(rueda)=14.802*omegar2(rueda)+70;
            elseif omegar2(rueda)<-wr2max
                PWMr2(rueda)=-pwmr2max;
            elseif omegar2(rueda)<0;
                PWMr2(rueda)=14.802*omegar2(rueda)-70;
            elseif omegar2(rueda)==0
                omegar2(rueda)=0;
            end
            
        end
          
        
        %Robot 1 envio bluetooth
        
        disp('PWM1')
        disp(PWMr1)
        disp('PWM2')
        disp(PWMr2)
        
        error=abs(error)
        
        if error(1)>toleranciaAlError || error(2)>toleranciaAlError || error(2)>toleranciaAlError || error(3)>toleranciaAlError

            try
                Msg='{"Motor1.1":"%0.3d", "Motor1.2":"%0.3d", "Motor2.1":"%0.3d","Motor2.2":"%0.3d","tiempo":"0250"}';
                envio=sprintf(Msg,floor(PWMr1(1)),floor(PWMr1(2)),floor(PWMr1(3)),floor(PWMr1(4)))% floor() PARTE ENTERAAAAAAA
                
                if(R1ON==1)
                   fwrite(r1,envio);
                end

                Msg='%d,%df'
                envio=sprintf(Msg,floor(PWMr2(1)),floor(PWMr2(2)))% floor() PARTE ENTERAAAAAAA

                if(R2ON==1)
                    fwrite(r2,envio)
                end
                
                pause(0.500) 
                
            catch
                warning('BLOTOOTH PROBLEM')
                
                if(R1ON==1)
                    fclose(r1);
                end
                if(R2ON==1)
                    fclose(r2);
                end
                break;
            end
        else
            disp('Llego al Destino!!!')
            %z1d=input('Siguiente punto del robot 1 en la formacion ')
            %z2d=input('Siguiente punto del robot 2 en la formacion ')
            
%             try 
%                 iteradorTrayectoria=iteradorTrayectoria+1;
%             catch
%                 iteradorTrayectoria=0;
%             end
%             
%             z1d=circulo(RadioCirculo,0,0,iteradorTrayectoria);
%             z2d=[0;0]
                        
%             if(R1ON==1)
%                 fclose(r1);
%             end
%             if(R2ON==1)
%                 fclose(r2);
%             end
%             break;

        end
    end
end

function Siguiente=circulo(r,x,y,dientes)
    Siguiente(1,1)= x + r * cos(2 * pi * dientes / 100);
    Siguiente(2,1)= y + r * sin(2 * pi * dientes / 100);
end