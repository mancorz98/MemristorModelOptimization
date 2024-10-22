function ME = Optim_MMS(U_m,I_m, t, parameter,check,Rs,weigth)
    [X,G,V,I] = MMS_Memristor_RK4(t,parameter,U_m,Rs);

    U_mem = U_m - Rs*I_m;

    RSS = sum((I_m - I).^2);
    RSS_u = sum((U_mem - V).^2);
    TSS = sum((I_m - mean(I_m)).^2);
    TSS_u = sum((U_mem - mean(U_mem)).^2);

    X_var = ((X(1)-X(end))/X(1))^2;

    if check == true
        ME = (RSS/TSS)+(RSS_u/TSS_u) + X_var*weigth ;
    else
         ME = (RSS/TSS)+(RSS_u/TSS_u);
    end
end

