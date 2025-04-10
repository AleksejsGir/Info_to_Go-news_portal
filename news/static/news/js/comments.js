// static/news/js/comments.js
document.addEventListener('DOMContentLoaded', function() {
    console.log('Система комментариев инициализирована');

    // 1. Настройка формы для ответов на комментарии
    const commentForm = document.getElementById('commentForm');
    const parentIdField = commentForm ? commentForm.querySelector('input[name="parent_id"]') : null;
    const cancelReplyBtn = document.getElementById('cancelReply');
    const commentTextarea = commentForm ? commentForm.querySelector('textarea') : null;

    console.log('Форма комментариев найдена:', !!commentForm);
    console.log('Поле parent_id найдено:', !!parentIdField);
    console.log('Кнопка отмены найдена:', !!cancelReplyBtn);

    // Обработка кнопок "Ответить"
    if (commentForm && parentIdField) {
        document.querySelectorAll('.reply-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const commentId = this.getAttribute('data-comment-id');
                const username = this.getAttribute('data-username');

                console.log(`Ответ на комментарий ${commentId} от ${username}`);

                // Устанавливаем ID родительского комментария
                parentIdField.value = commentId;

                // Обновляем плейсхолдер и фокус
                if (commentTextarea) {
                    commentTextarea.placeholder = `Ответ для ${username}...`;
                    commentTextarea.focus();
                }

                // Показываем кнопку отмены
                if (cancelReplyBtn) {
                    cancelReplyBtn.classList.remove('d-none');
                }

                // Прокручиваем к форме
                commentForm.scrollIntoView({behavior: 'smooth'});
            });
        });

        // Обработка кнопки "Отменить ответ"
        if (cancelReplyBtn) {
            cancelReplyBtn.addEventListener('click', function() {
                parentIdField.value = '';

                if (commentTextarea) {
                    commentTextarea.placeholder = 'Напишите комментарий...';
                }

                this.classList.add('d-none');
            });
        }
    }

    // 2. Обработка лайков и дизлайков комментариев
    const likeButtons = document.querySelectorAll('.reaction-btn');
    console.log(`Найдено ${likeButtons.length} кнопок лайк/дизлайк`);

    likeButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();

            const commentId = this.getAttribute('data-comment-id');
            const action = this.getAttribute('data-action');

            console.log(`Клик на ${action} для комментария ${commentId}`);

            // Предотвращаем множественные клики
            if (this.classList.contains('processing')) {
                console.log('Запрос уже обрабатывается');
                return;
            }

            // Добавляем анимацию пульсации
            this.classList.add('pulse');
            setTimeout(() => this.classList.remove('pulse'), 500);

            this.classList.add('processing');

            // Получаем CSRF токен
            const csrftoken = getCsrfToken();
            console.log('CSRF токен:', csrftoken ? 'Получен' : 'Не найден');

            // Формируем данные запроса
            const formData = new FormData();
            formData.append('action', action);

            // Отправляем AJAX запрос
            fetch(`/news/comment/like/${commentId}/`, {
                method: 'POST',
                headers: {
                    'X-CSRFToken': csrftoken
                },
                body: formData,
                credentials: 'same-origin'
            })
            .then(response => {
                console.log(`Ответ сервера: статус ${response.status}`);

                if (!response.ok) {
                    if (response.status === 401) {
                        window.location.href = '/users/login/?next=' + window.location.pathname;
                        throw new Error('Требуется авторизация');
                    }
                    throw new Error(`Ошибка сервера: ${response.status}`);
                }

                return response.json();
            })
            .then(data => {
                console.log('Данные от сервера:', data);

                if (data.success) {
                    // Находим контейнер комментария
                    const commentItem = this.closest('.comment-item');

                    // Обновляем счетчики
                    const likesCount = commentItem.querySelector('.comment-likes-count');
                    const dislikesCount = commentItem.querySelector('.comment-dislikes-count');

                    if (likesCount) likesCount.textContent = data.likes_count;
                    if (dislikesCount) dislikesCount.textContent = data.dislikes_count;

                    // Обновляем состояние кнопок
                    const likeBtn = commentItem.querySelector('.like-btn');
                    const dislikeBtn = commentItem.querySelector('.dislike-btn');

                    if (action === 'like') {
                        if (likeBtn) likeBtn.classList.toggle('active', data.is_active);
                        if (dislikeBtn) dislikeBtn.classList.remove('active');
                    } else {
                        if (dislikeBtn) dislikeBtn.classList.toggle('active', data.is_active);
                        if (likeBtn) likeBtn.classList.remove('active');
                    }
                } else {
                    console.error('Ошибка:', data.error);
                    alert('Произошла ошибка при обработке действия');
                }
            })
            .catch(error => {
                console.error('Ошибка при выполнении запроса:', error);
                if (!error.message.includes('Требуется авторизация')) {
                    alert('Произошла ошибка при отправке запроса');
                }
            })
            .finally(() => {
                this.classList.remove('processing');
            });
        });
    });

    // Вспомогательные функции
    function getCsrfToken() {
        // Сначала ищем в форме
        const csrfInput = document.querySelector('[name=csrfmiddlewaretoken]');
        if (csrfInput) return csrfInput.value;

        // Иначе ищем в куках
        return getCookie('csrftoken');
    }

    function getCookie(name) {
        let cookieValue = null;
        if (document.cookie && document.cookie !== '') {
            const cookies = document.cookie.split(';');
            for (let i = 0; i < cookies.length; i++) {
                const cookie = cookies[i].trim();
                if (cookie.substring(0, name.length + 1) === (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
});