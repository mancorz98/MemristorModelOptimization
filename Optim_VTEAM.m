function ME = Optim_VTEAM(U_m,I_m, t, parameter,check,a,Rs,weight)


    [X,~,V,I] = VTEAM_model(t,parameter,U_m,a,Rs);

    U_mem = U_m - Rs*I_m;


    RSS = sum((I_m - I).^2);
    RSS_u = sum((U_mem - V).^2);
    TSS = sum((I_m - mean(I_m)).^2);
    TSS_u = sum((U_mem - mean(U_mem)).^2);

    

    if check == true
        X_var = ((X(1)-X(end))/X(1))^2;
        ME = (RSS/TSS)+(RSS_u/TSS_u) + X_var*weight;
    else
         ME =(RSS/TSS)+(RSS_u/TSS_u);
    end

end