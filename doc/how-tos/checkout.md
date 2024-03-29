
# Инструкция для показа формы оплаты

После [установки SDK](./setup.md) можно начинать принимать оплату.

Для этого используется метод `startCheckoutFlow` или 
`startCheckoutWithSavedCardFlow`.

## Оглавление

- [Оплата заказа без использования функционала сохраненных карт](#оплата-заказа-без-использования-функционала-сохраненных-карт)
  - [1. Отобразить экран оформления заказа](#1-отобразить-экран-оформления-заказа)
  - [2. Вызвать метод своего бэкенда для создания заказа](#2-вызвать-метод-своего-бэкенда-для-создания-заказа)
  - [3. Вызвать метод оплаты в SDK](#3-вызвать-метод-оплаты-в-sdk)
  - [3.1. Обработка результата](#31-обработка-результата)
- [Оплата заказа с использованием функционала сохраненных карт](#оплата-заказа-с-использованием-функционала-сохраненных-карт)
  - [1. Отобразить экран оформления заказа](#1-отобразить-экран-оформления-заказа-1)
  - [2. Получить сохраненные карты пользователя](#2-получить-сохраненные-карты-пользователя)
  - [3. Отобразить сохраненные карты в своем интерфейсе](#3-отобразить-сохраненные-карты-в-своем-интерфейсе)
  - [4. Вызвать метод своего бэкенда для создания заказа](#4-вызвать-метод-своего-бэкенда-для-создания-заказа)
  - [5. Вызвать метод оплаты в SDK](#5-вызвать-метод-оплаты-в-sdk)
  - [5.1. Метод оплаты сохраненной картой](#51-метод-оплаты-сохраненной-картой)
  - [5.2. Метод оплаты новой картой](#52-метод-оплаты-новой-картой)

## Оплата заказа без использования функционала сохраненных карт

Для оплаты заказа новой картой используется метод `startCheckoutFlow`. Пошаговый
алгоритм таков:

[1. Отобразить экран оформления заказа](#1-отобразить-экран-оформления-заказа)

[2. Вызвать метод своего бэкенда для создания заказа](#2-вызвать-метод-своего-бэкенда-для-создания-заказа)

[3. Вызвать метод оплаты в SDK](#3-вызвать-метод-оплаты-в-sdk)

- [3.1. Обработка результата](#31-обработка-результата)

### 1. Отобразить экран оформления заказа

Этот экран предоставляет пользователю возможность проверить заказанные товары
и общую сумму заказа, выбрать время и адрес доставки. В этом экране должна быть 
кнопка "Оплатить", которая непосредственно создаёт сам заказ.



### 2. Вызвать метод своего бэкенда для создания заказа

При нажатии на кнопку необходимо сначала создать заказ на сервере и получить 
`order_access_token`.

```Swift
let orderAccessToken = myBackEnd.createOrderAccessToken()
```

### 3. Вызвать метод оплаты в SDK

После создания заказа на сервере необходимо вызвать метод 
`Ioka.shared.startPaymentFlow()`, передав туда
`order_access_token` и `sourceViewController`:

```Swift
    Ioka.shared.startPaymentFlow(sourceViewController: sourceViewController, orderAccessToken: orderAccessToken, applePayState: .disable) { result in
        print(result)
    }
```

### 3.1. Обработка результата

Метод `startCheckoutFlow` возвращает `completion` типа `FlowResult` - 
подробнее об этом классе можно прочитать в документации API.

В случае, если пользователь прервал оплату, то функция возвращает `cancelled`.

Этим можно воспользоваться, например, чтобы очистить корзину при успешном
оформлении заказа:


## Оплата заказа с использованием функционала сохраненных карт

Для оплаты заказа сохраненной картой используется метод 
`startCheckoutWithSavedCardFlow`, в которую нужно передать объект карты. В 
целом, шаги оплаты выглядят так:

[1. Отобразить экран оформления заказа](#1-отобразить-экран-оформления-заказа-1)

[2. Получить сохраненные карты пользователя](#2-получить-сохраненные-карты-пользователя)

[3. Отобразить сохраненные карты в своем интерфейсе](#3-отобразить-сохраненные-карты-в-своем-интерфейсе)

[4. Вызвать метод оплаты в SDK](#4-вызвать-метод-оплаты-в-sdk)
- [4.1. Метод оплаты сохраненной картой](#41-метод-оплаты-сохраненной-картой)
- [4.2. Метод оплаты новой картой](#42-метод-оплаты-новой-картой)


### 1. Отобразить экран оформления заказа

Помимо информации о заказе, этот экран должен предоставить пользователю
возможность выбрать карту для оплаты.

Перед показом этого экрана мы должны заранее создать заказ на сервере и 
сохранить `customer_access_token` и `order_access_token` в переменных.


### 2. Получить сохраненные карты пользователя

Для получения сохраеннных карт пользователя  можно вызывать метод 
`Ioka.shared.getCards()`, передав в него `customer_access_token`:

```Swift
Ioka.shared.getCards(customerAccessToken: customerAccessToken) { cards in
   print(cards)
}
```

### 3. Отобразить сохраненные карты в своем интерфейсе

Если необходимо добавить функционал удаления карт в этой странице, то об этом
можно прочитать в [инструкции](./save-and-delete-cards.md).

<br clear="right">

### 4. Вызвать метод оплаты в SDK

Если пользователь выбрал сохраненную карту, то необходимо использовать метод
`Ioka.instance.startPaymentWithSavedCardFlow()`, передав в него `sourceViewController`,
`orderAccessToken` и `savedCard`.

Иначе, необходимо вызвать метод оплаты новой картой -
`Ioka.instance.startPaymentFlow()`, передав в него `sourceViewController`, 
`orderAccessToken`.

### 4.1. Метод оплаты сохраненной картой

При нажатии на кнопку оформления заказа, после создания заказа на сервере
можно вызывать оплату:

```Swift
// Выбранная пользователем карта
let savedCard = ...;

func buttonPressed() {
    Ioka.shared.startPaymentWithSavedCardFlow(sourceViewController: sourceViewController, orderAccessToken: orderAccessToken, card: savedCard) { result in
    print(result)
}
}
```

### 4.2. Метод оплаты новой картой

Этот метод такой же, как и в 
[оплата заказа без использования функционала сохраненных карт](#3-вызвать-метод-оплаты-в-sdk).


Подробнее о взаимодействиях с сохраненными картами можно прочитать в 
[соответствующей инструкции](./save-and-delete-cards.md).
