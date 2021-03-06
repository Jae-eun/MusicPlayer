# Music Player

| 앨범 목록 화면                                               | 앨범 상세, 현재 재생 곡 화면                                 |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![](https://user-images.githubusercontent.com/12438429/140794359-65d9cd92-2ec5-4014-845f-d97a8f8ad42d.gif) | ![](https://user-images.githubusercontent.com/12438429/140795342-51cb9afc-b66b-42e9-b4a3-2342751e25b3.gif) |

> * 애플뮤직에서 사용자가 저장한 '앨범' 가져옴



## *기능

### 앨범 목록 화면

* 앨범 목록을 확인할 수 있음.
* 앨범 상세 화면으로 이동 가능함.



### 상세 곡 정보 화면

* 앨범에 수록된 곡 목록 정보 확인 가능함.

* 처음부터 순차적으로 또는 특정 음악 재생 가능함.

* 임의 순서로 재생 가능함. 

  

### 현재 재생 곡 화면

* 현재 재생되는 곡을 일시정지, 다음 곡, 이전 곡 변경 가능함.
* 반복이나 랜덤 재생 설정 가능함.
* 볼륨 조절 가능함. 



### 하단 플레이어뷰

* 음악 재생/일시정지 가능함.
* 현재 재생 곡 화면으로 이동 가능함.



## * 구조

### MVC(Model - View - Controller) 아키텍처



## * 역할

### 화면 관련

| Class 이름              | 역할                                                         |
| ----------------------- | ------------------------------------------------------------ |
| BaseViewController      | BottomPlayerView가 표시될 수 있는 화면들이 상속하는 부모 뷰컨트롤러. |
| AlbumListViewController | 앨범 목록을 확인할 수 있음.                                  |
| AlbumCollectionViewCell | 앨범 목록 화면의 컬렉션뷰셀.                                 |
| DetailViewController    | 앨범에 수록된 곡 목록을 확인하고, 재생할 수 있음.            |
| SongTableViewCell       | 곡 정보를 표시하는 테이블뷰셀.                               |
| PlayingViewController   | 현재 재생하는 곡을 확인할 수 있음.                           |
| BottomPlayerView        | 화면 하단에 표시되는 미니 플레이어 뷰.                       |



### 로직 관련

| Class 이름    | 역할                                    |
| ------------- | --------------------------------------- |
| PlayerService | 플레이어 관련 기능이 구현된 싱글턴 객체 |



## * 사용한 라이브러리

### SnapKit, Then

* 코드로 UI를 구현할 때 효율적이며, 알아보기 보다 더 명확하도록 사용함.