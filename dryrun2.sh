
#!/bin/sh
argo_path="config/argocd/"
if [ -d ${argo_path} ]
then
   printf "Apply $(basename ${argo_path}) environment\n"
   kubectl apply --dry-run=server -k "${argo_path}config"
   is_argocd=true
fi
for dir in `ls -d environments/*/`
do
    printf "\nApply $(basename ${dir}) environment\n"
    kubectl apply --dry-run=server -k "${dir}env/overlays"
    # apply each app inside environment
    if [ -d "${dir}apps" ]
    then
        for app in `ls -d ${dir}apps/*/`
        do
            printf "\nApply $(basename ${app}) application\n"
            kubectl apply --dry-run=server -k $app
        done
    fi
done
