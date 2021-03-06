# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

Бывает, что 
* общедоступная документация по терраформ ресурсам не всегда достоверна,
* в документации не хватает каких-нибудь правил валидации или неточно описаны параметры,
* понадобиться использовать провайдер без официальной документации,
* может возникнуть необходимость написать свой провайдер для системы используемой в ваших проектах.   

## Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  


1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.  
>
> data_source перечислены в файле [https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L423](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L423)
> 
> resource перечислены в файле [https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L902](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L902) 
> 

2. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
      > Конфликтует с параметром name_prefix [https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L87](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L87)
    * Какая максимальная длина имени?
      > 80 [https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L427](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L427)
    * Какому регулярному выражению должно подчиняться имя?
      > ^[a-zA-Z0-9_-]{1,80}$ (большие и маленькие латинские буквы, цифры, тире, подчерк, длина от 1 до 80) [https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L427](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L427)
    
## Задача 2. (Не обязательно) 
В рамках вебинара и презентации мы разобрали как создать свой собственный провайдер на примере кофемашины. 
Также вот официальная документация о создании провайдера: 
[https://learn.hashicorp.com/collections/terraform/providers](https://learn.hashicorp.com/collections/terraform/providers).

1. Проделайте все шаги создания провайдера.
2. В виде результата приложение ссылку на исходный код.
3. Попробуйте скомпилировать провайдер, если получится то приложите снимок экрана с командой и результатом компиляции.   

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---