# QNAP TS-469L上で動作するmackerel-agentを作成するためのビルド環境

## 必要なもの

windowsで作業する場合

- VirtualBox
- Vagrant
- Gitクライアント(git,sourcetreeなど)

## 手順

1. [これ](https://github.com/mistymagich/mackerel-qnapnas-build.git)をcloneする。以降このフォルダを作業ディレクトリとする

2. 作業ディレクトリ内に[mackerel-agent](https://github.com/mackerelio/mackerel-agent.git)をクローン。

    この時点でのディレクトリ構成は

    ```
    mackerel-qnapnas-build/
        mackerel-agent/
        build.sh
        Dockerfile
        provision.sh
        Readme.md
        Vagrantfile
    ```

    となっている。

3. mackerel-agent内の以下の場所を修正する。

	- spec/linux/kernel.goのunameコマンドの-oオプションを取り除く

        ```diff
        @@ -27,7 +27,6 @@
                "release": []string{"uname", "-r"},
                "version": []string{"uname", "-v"},
                "machine": []string{"uname", "-m"},
        -		"os":      []string{"uname", "-o"},
            }

            results := make(map[string]string)
        @@ -41,6 +40,8 @@

                results[key] = str
            }
        +
        +    results["os"] = "Linux"

            return results, nil
         }
        ```

	- util/filesystem.goのdfコマンドの-Pオプションを取り除いて、-ckオプションを加える

        ```diff
        @@ -51,7 +51,7 @@
            case "netbsd":
                dfOpt = []string{"-Pkl"}
            default:
        -		dfOpt = []string{"-P"}
        +		dfOpt = []string{"-ck"}
            }
         }
        ```

4. コマンドプロンプトなどを起動し、作業ディレクトリに移動しvagrantでサーバを起動する。

    ```bash
    vagrant up
    ```

5. 起動後引き続いて、ビルドが実行され、成功すれば **_mackerel-agent** が生成されている


## Memo

### TS-210対応

TS-469LはCPUがIntelのAtomである。一方TS-210はMarvell製のCPUでアーキテクチャがARMとなっており、上記のバイナリではそのまま動作しないがビルドオプションを変更することで動作する。

変更方法

 1. 手順3の際、追加でmackerel-qnapnas-buildのDockerfile内のGOARCHをamd64からarmに変更する

### ビルドのやり直し

ビルドをやり直したい場合は、生成済みの_mackerel-agentを削除したのち、vagrant provisionを実行する
