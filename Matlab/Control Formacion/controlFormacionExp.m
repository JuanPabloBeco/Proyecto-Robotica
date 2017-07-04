function [Phi,dientes,error] = controlFormacionExp( z1central, z1frontal, z2central, z2frontal, dientes )
% %Control de formacion explicito
% %Entrada: Posiciones frontales de los agentes(x,y)
% %     if dientes<100
% %         dientes=dientes+1;
% %     else
% %         dientes=0;
% %     end
%   
    
    r=0.3;
    k=0.2*eye(4,4);           %Se asigna matriz identidad para la constante del control
%     k=[1 0 0 0;
%        0 1 0 0;
%        0 0 1 0;
%        0 0 0 1];
    k2=1;
    
    Ad=[0 1;
        1 0];
    delta=[sum(Ad(1,:)) 0;
           0 sum(Ad(2,:))];
    Laplaciana=delta-Ad;  %Matriz laplaciana
      
    L=0.036;%Distancia del eje de ruedas al centro del robot.
    
    %Robot
    Rrueda=0.03;
%   Variables generales
    
    e=0.1;

    z1d=[0.40;0];%Distancia de formacion deseada entre los dos agente.
    z2d=[0;0];
    
    c12=z2d-z1d;
    c21=z1d-z2d;

    Cij=[c21;c12];
    
    zfrontal=[z1frontal;z2frontal];
    
    SigPunto=[0,0];%circulo(r,dientes);
    derSigPunto(1:2)=derivTrayectoria();
    
    %derCamino=[ derSigPunto-k2*(z1frontal-SigPunto);derSigPunto];
    
    rRob=0.07;
    eta=0.00001;
    Qate=0.06;
    PotRepulsivo=[Repulsivo((z1frontal+z1central)/2,(z2frontal+z2central)/2,rRob,Qate,eta);Repulsivo((z2frontal+z2central)/2,(z1frontal+z1central)/2,rRob,Qate,eta)];
    disp('PotRepulsivo');
    disp(PotRepulsivo);
    un=-k*((kron(Laplaciana,eye(2,2))*(zfrontal))-Cij)-PotRepulsivo;%+derCamino;  %Ecuacion en forma matricial para la señal de control
    
    disp('distancias entre robots')
    disp((kron(Laplaciana,eye(2,2))*(zfrontal)))
    disp('un')
    disp(un)
    
    x1f=z1frontal(1);
    y1f=z1frontal(2);
    x1c=z1central(1);
    y1c=z1central(2);   
    x2f=z2frontal(1);
    y2f=z2frontal(2);
    x2c=z2central(1);
    y2c=z2central(2);  
    
    if (x1f == x1c)
        if (y1f<y1c)
            theta1=pi/2;
        else
            theta1=-pi/2;
        end
    elseif (x1f>x1c)
        theta1=atan((z1frontal(2)-z1central(2))/(z1frontal(1)-z1central(1)));
    elseif (y1f<y1c)
        theta1=atan((z1frontal(2)-z1central(2))/(z1frontal(1)-z1central(1)))-pi;
    else
        theta1=atan((z1frontal(2)-z1central(2))/(z1frontal(1)-z1central(1)))+pi;
    end
    
    if (x2f==x2c)
        if (y2f<y2c)
            theta2=pi/2;
        else
            theta2=-pi/2;
        end
    elseif (x2f>x2c)
        theta2=atan((z2frontal(2)-z2central(2))/(z2frontal(1)-z2central(1)));
    elseif (y2f<y2c)
        theta2=atan((z2frontal(2)-z2central(2))/(z2frontal(1)-z2central(1)))-pi;
    else
        theta2=atan((z2frontal(2)-z2central(2))/(z2frontal(1)-z2central(1)))+pi;
    end
    
    A1 = [cos(theta1), -e * sin(theta1);
          sin(theta1), e * cos(theta1)];
    u1 = inv(A1) * un(1:2);
  
%    u1 = [1,0];
    disp('u1');
    disp(u1);
    
    A2 = [cos(theta2), -e * sin(theta2);
          sin(theta2), e * cos(theta2)];
    u2 = inv(A2) * un(3:4);
    
%     u2 = [0.5,0]
    
    
    u2(2) = -u2(2);
    disp('u2');
    disp(u2);
    
    vmax=5.67;
    thetapuntomax=3.378;%Velocidad angular máxima
    
    if (u1(1)>vmax)
        u1(1)=vmax;
    elseif(u1(1)<-vmax)
        u1(1)=-vmax;
    end
    
    if (u2(1)>vmax)
        u2(1)=vmax;
    elseif(u2(1)<-vmax)
        u2(1)=-vmax;
    end
       
    if (u1(2)>thetapuntomax)
        u1(2)=thetapuntomax;
    elseif(u1(2)<-thetapuntomax)
        u1(2)=-thetapuntomax;
    end
    
    if (u2(2)>thetapuntomax)
        u2(2)=thetapuntomax;
    elseif(u2(2)<-thetapuntomax)
        u2(2)=-thetapuntomax;
    end
    
    
    Phi1R1=(1/Rrueda)*(u1(1)+L*u1(2));% rueda de la derecha
    Phi1R2=(1/Rrueda)*(u1(1)-L*u1(2));%rueda de la izquierda
    
    
    Phi2R1=(1/Rrueda)*(u2(1)+L*u2(2));% rueda de la derecha
    Phi2R2=(1/Rrueda)*(u2(1)-L*u2(2));%rueda de la izquierda
    

    Phi=[Phi1R1,Phi1R2,Phi2R1,Phi2R2];
    
%ERROR ANTERIOR
%     zobjetivo(1) = SigPunto;
%     zobjetivo(2) = z1frontal + c12;
%     
%     zerror = zfrontal - zobjetivo
    
%ERROR NUEVO

    error=[z1frontal-z2frontal-c21;z2frontal-z1frontal-c12];
    plot(norm(error(3:4)),dientes,'.')
    plot(norm(u2),dientes,'x')
    disp(error)


    end

% function [b] = Trayectoria(t)
%     if distancia ==0
%         Pi=[inicio;pEvitar;inicio]';
%     else
%         dMas=pEvitar(1,:)-inicio();
%         l=length(pEvitar(1,:));
%         dMenos=pEvitar(1,:)-inicio();
%         der=(dMas-dMenos)/2;
%         Pi=[inicio;inicio+[ ]
%         
%     end
% end

function Siguiente=circulo(r,dientes)
    Siguiente(1)= r * cos(2 * pi * dientes / 100);
    Siguiente(2)= r * sin(2 * pi * dientes / 100);
end


function [x,y] = derivTrayectoria()
    x=1;
    y=2;
end

function [rep]=Repulsivo(z1r,z2r,rRob,r,eta)
    %rRob : Radio del robot 0,013m
    %eta = constante del repulsivo
    %r=radio 
    d=norm(z1r-z2r)-2*rRob;
    if d>r
        rep=[0;0];
    else
        rep=eta*((1/r)-(1/d))*(1/d^2)*((z1r-z2r)/norm(z1r-z2r));
    end
end