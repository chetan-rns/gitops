
#!/bin/sh
is_argocd=false
argo_path="config/argocd/"
cicd_path="config/chetan-cicd/"
# apply argo files if Argo CD is used
if [ -d ${argo_path} ]
then
   printf "Apply $(basename ${argo_path}) environment\n"
   kubectl apply --dry-run=client -k "${argo_path}config"
   is_argocd=true
fi
if [ -d ${cicd_path} ]
then
   printf "Apply $(basename ${cicd_path}) environment\n"
   kubectl apply --dry-run=client -k "${cicd_path}overlays"
   is_argocd=true
fi
for dir in $(ls -d environments/*/)
do
   # apply the env if Argo CD is not used
   if [ ! ${is_argocd} ]
   then
       printf "\nApply $(basename ${dir}) environment\n"
       env_path="${dir}env/overlays"
       kubectl apply --dry-run=client -k $env_path
   else
       # apply each app if Argo CD is used
       if [ -d "${dir}apps" ]
       then
           for app in `ls -d ${dir}apps/*/`
           do
               printf "\nApply $(basename ${app}) application\n"
               kubectl apply --dry-run=client -k $app
           done
       else 
               printf "\nApply $(basename ${dir}) environment\n"
               env_path="${dir}env/overlays"
               kubectl apply --dry-run=client -k $env_path
       fi
   fi
done
