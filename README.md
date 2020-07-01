# AlfaMerger

Зачем?

Проблема

В альфабанке в CSV файле можно получить список транзакций только по счету.

Любые переводы со счета на счет отображаются в CSV как отдельные транзакции, имеющие пару признаков, и все.

Если имортировать такие файлы куда либо, мы получаем эффект "задваивания", когда один и тот же перевод отображается не как трансфер, а как две тразакции, из счета А ушло, в счет Б пришло

В рамках одного счета это верное поведение, но в рамках всех счетов нет, так как это портит статистику инкама/ауткама - софт который отображет это все должен знать что это трансфер

Эта утилита позволяет выгружать такую CSV, в которой сразу ясно и понятно, что это трансфер, и с какого на какой аккаунт этот трансфер был произведен

По сути мы превращяем список тразакции в транзакции с инкам/ауткам счетом, где в случае трансфера оба поля заполнены 

! Альфабанк позволяет себе дублировать рефы для определенных внутренних типов транзакций, что рождает "КОСТЫЛИ И ВЕЛОСИПЕДЫ" при попытке нормализовать транзакцию

- Предоставление транша 
- Погащение ОД
- Некоторые CASHIN на разных счетах 
- Отмены транзакций в один день 
- Начисления процентов
- Старое снятие задолжностей с других счетов

Примеры ниже

```csv
tmp/movementList_eur.csv:"Счет EUR";"-";"EUR";"25.06.15";"CASHIN200308";"{VO99090}2.7  Внесение средств через устройство Recycling 200308 на счет. -";250;0
tmp/movementList_zp.csv:"Текущий зарплатный счёт";"-";"RUR";"02.11.15";"CASHIN200308";"Внесение средств через устройство Recycling 200308 на счет. -";15000;0
```

```csv
tmp/movementList_eur.csv:"Счет EUR";"-";"EUR";"12.02.14";"AA90X12061300303";"- Перевод средств с доп. счетов для погаш. задолж.. по кредитным догов. Дог. - от 130612";0;4,4
tmp/movementList_seif.csv:"Мой сейф";"-";"RUR";"09.09.13";"AA90X12061300303";"- Перевод средств с доп. счетов для погаш. задолж.. по кредитным догов. Дог. - от 130612";0;248,97
tmp/movementList_seif.csv:"Мой сейф";"-";"RUR";"11.07.13";"AA90X12061300303";"- Перевод средств с доп. счетов для погаш. задолж.. по кредитным догов. Дог. - от 130612";0;295,45
```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alfa_merger'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install alfa_merger

## Usage

```bash

alfa_merger init
alfa_merger import some_tr.csv
```


iconv -f windows-1251 -t UTF-8//TRANSLIT 2017-2018.csv -o qwe.csv
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bigforcegun/alfa_merger. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/alfa_merger/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) 2020 BigForceGun. See [MIT License](LICENSE.txt) for further details.