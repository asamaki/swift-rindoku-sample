# swift-rindoku-sample
## AppDelegate.swift
* アプリ起動、アプリがバックグラウンドになった、アプリが終了したといった、起動や終了のイベントを受け取る
* アプリ起動直後に表示する画面を表示したり、終了時にデータの保存処理をしたり…といった処理を書くところ

## ListViewController.swift
* UITableViewが画面いっぱいのサイズで置いてあるViewController
* delegate, dataSourceは未設定
  * このまま実行すると空のTableViewが表示される

### ListViewController.xib
* ListViewController.swiftの見た目を設定している
* こっちはほぼいじらなくて良い
