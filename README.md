# ioka-ios

iOS SDK для [ioka](https://ioka.kz).

## Оглавление
- [Оглавление](#оглавление)
- [Установка](#установка)
- [Использование](#использование)
- [Доступный функционал](#доступный-функционал)
- [Документация](#документация)

## Установка

## Cocoapods
```yaml
pod 'Ioka' '~> 1.0.6'
```

## Использование

Для того, чтобы пользоваться SDK, вам нужно зарегистрироваться 
[по ссылке](https://ioka.kz/contact-form) и получить публичный ключ для 
приложения.

В (`AppDelegate`) вам нужно инициализировать SDK:

```Swift
Ioka.shared.setup(apiKey: String, theme: Theme = .default, locale: IokaLocale = .automatic, applePayConfiguration: ApplePayConfiguration)
```

Режим SDK (`staging` или `production`) определяется автоматически в зависимости 
от значения публичного ключа.

Чтобы начать платёж, вам нужно создать заказ на сервере и передать 
`orderAccessToken`:

```Swift
let  orderAccessToken = ...

Ioka.shared.startPaymentFlow(sourceViewController: UIViewController, orderAccessToken: String, applePayState: ApplePayState = .disable) { [weak self] in result
}
```

Подробнее о том как интегрировать серверную часть для работы с ioka sdk можно узнать [здесь](https://docs.google.com/document/d/1baMx2I1vHoWYBC0x5fZbDIVAj5kR7YDy5A12lXlpfT8/edit#heading=h.atr9ary48uhs).

Подробнее об использовании каждого метода можете узнать в 
[документации](./doc/README.md) либо в [демо-приложении](./demo/lib/main.dart).

## Доступный функционал

- [x] Форма оплаты новой и сохраненной картой
- [x] Возможность сохранять карту у пользователя
- [x] Подтверждение оплаты через 3D Secure
- [x] Кастомизация интерфейсов
- [ ] Полная кастомизация интерфейсов 
- [x] Автоматическая кастомизация
- [x] Apple Pay
- [x] Локализация
- [x] Документация (в разработке)
- [ ] Тестирование и мокинг (в разработке)

## Документация

Вся документация содержится в папке [doc](./doc), а также в виде inline
комментариев.
