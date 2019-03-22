# myListOfContacts
Приложение для отображения и редактирования карточек контактов.


Модель данных 
LCContact - структура описывающая сущность «Контакт»
Массив экземпляров LCContact инициализируется при загрузке контроллера списка контактов.

Контроллеры

LCListOfContactsViewController - контроллер списка контактов, он инициализируется и помещается в navigation stack при загрузке приложения. Отображает массив контактов с помощью tableView.

LCContactDetailViewController - контроллер детальной информации о контакте. Инициализируется и показывается из контроллера списка контактов (при нажатии на контакт или при добавлении нового контакта по кнопке «+»). Работает в режиме редактирования и в режиме создания нового элемента. Отображает свойства контакта  с помощью tableView.

LCImageSourceViewController - контроллер выбора источника данных картинки контакта. Инициализирется и показывается из контроллер детальной информации о контакте, при нажатии ячейку с фото.

LCSaveChangesQuestionViewController - контроллер выбора действия сохранить изменения или не сохранять. Инициализируется и показывается из контроллера детальной информации о контакте, при нажатии на кнопку «< Назад», при условии что контакт был изменен но не сохранен.