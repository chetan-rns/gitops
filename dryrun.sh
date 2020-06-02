is_argocd=false
argo_path="config/argocd/"
# apply argo files if Argo CD is used
if [ -d argo_path ]
    kubectl apply --dry-run -k "${argo_path}config"
fi
for dir in `ls -d environments/*/`
do
    # apply the env if Argo CD is not used
    if !is_argocd
    then
        env_path="${dir}env/overlays"
        kubectl apply --dry-run=true -k=$env_path
    else
        # apply each app if Argo CD is used
        for app in `ls -d ${dir}apps`
        do
            kubectl apply --dry-run=server -k=$app
        done
    fi
done