namespace :utility do
  desc 'レイアウト修正'
  task fix_layout: :environment do |_task, _args|
    sh 'rubocop --fix-layout app lib'
  end

  desc '構文チェック'
  task lint: :environment do |_task, _args|
    sh 'rubocop --rails --auto-correct app lib'
  end

  desc 'yardによるドキュメント生成'
  task doc: :environment do |_task, _args|
    sh 'yard doc'
  end

  desc 'erdによるER図作成'
  task erd: :environment do |_task, _args|
    sh 'erd --filename=doc/ER図'
  end

  desc 'asciidoctorによるpdf作成'
  task asciidoc: :environment do |_task, _args|
    sh 'cd ../deploy && asciidoctor-pdf -r asciidoctor-diagram ./documents/asciidoc/src/index.adoc'
  end

  desc '全て実行'
  task all: %i[fix_layout lint doc erd] do |_task, _args|
  end
end
