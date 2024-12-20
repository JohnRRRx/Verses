document.addEventListener("turbo:load", function () {
    const autoCompleteJS = new autoComplete({
      selector: "#autoComplete",
      placeHolder: "検索",
      data: {
        src: async (query) => {
          try {
            const response = await fetch(`/posts/autocomplete?q=${query}`);
            const data = await response.json();
            return data.map(item => item.value); // オートコンプリートの候補値を返す
          } catch (error) {
            console.error("Autocomplete fetch error:", error);
            return [];
          }
        },
        cache: false,
      },
      resultsList: {
        element: (list, data) => {
          if (!data.results.length) {
            const message = document.createElement("div");
            message.className = "no_result";
            message.innerHTML = `<span>検索結果が見つかりません "${data.query}"</span>`;
            list.prepend(message);
          }
        },
        noResults: true,
      },
      resultItem: { highlight: true },
      events: {
        input: {
          selection: (event) => {
            const selection = event.detail.selection.value;
            autoCompleteJS.input.value = selection;
  
            // 検索フォームを送信
            document.querySelector(".search-form").submit();
          },
        },
      },
    });
  
    // Enterキーで検索を送信（オートコンプリート外の直接入力対応）
    autoCompleteJS.input.addEventListener("keydown", function (event) {
      if (event.key === "Enter") {
        document.querySelector(".search-form").submit();
      }
    });
  });
