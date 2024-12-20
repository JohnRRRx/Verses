document.addEventListener("turbo:load", function () {
      const autoCompleteJS = new autoComplete({
      selector: "#autoComplete",
      placeHolder: "検索",
      data: {
        src: async (query) => {
          try {
            const response = await fetch(`/posts/autocomplete?q=${query}`);
            const data = await response.json();
            return data.map((item) => item.value);
          } catch (error) {
            console.error("Error fetching autocomplete data:", error);
            return [];
          }
        },
        cache: false,
    },
    resultsList: {
      element: (list, data) => {
        if (!data.results.length) {
          allowInput = false;
          const message = document.createElement("div");
        //   message.setAttribute("class", "no_result");
          message.innerHTML = `<span>結果がありません "${data.query}"</span>`;
          list.prepend(message);
        }
      },
      noResults: true,
    },
      resultItem: {
        highlight: true, // 通常のハイライト設定
      },
      events: {
        input: {
          selection: (event) => {
            const selection = event.detail.selection.value;
            autoCompleteJS.input.value = selection;
  
            // 検索フォームを送信
            const form = document.querySelector(".search-form");
            form.submit();
          },
        },
      },
    });
  
    // Enterキーで通常検索を実行
    document.querySelector("#autoComplete").addEventListener("keydown", function (event) {
      if (event.key === "Enter") {
        const form = document.querySelector(".search-form");
        form.submit();
      }
    });
  });
