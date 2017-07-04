function a = ola()
    dientes = 0;
        while dientes<101
            if dientes<100
                dientes=dientes+1;
            else
                dientes=0;
                plot(a(1,:),a(2,:));
                break;
            end
            a(:,dientes)=circulo(10,10,20,dientes);
    
        end
    

end

function Siguiente=circulo(r,x,y,dientes)
    Siguiente(1)= x + r * cos(2 * pi * dientes / 100);
    Siguiente(2)= y + r * sin(2 * pi * dientes / 100);
end
