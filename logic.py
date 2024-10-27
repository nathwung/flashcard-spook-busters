import pygame
import random
import time

# Initialize Pygame
pygame.init()

# Game Constants
SCREEN_WIDTH, SCREEN_HEIGHT = 800, 600
BACKGROUND_COLOR = (34, 45, 67)  # Dark blue background
WHITE, RED, GREEN, BLACK, BLUE, LIGHT_BLUE = (255, 255, 255), (255, 0, 0), (0, 255, 0), (0, 0, 0), (0, 153, 204), (173, 216, 230)
FONT = pygame.font.Font(pygame.font.get_default_font(), 28)
LARGE_FONT = pygame.font.Font(pygame.font.get_default_font(), 42)

# Game Variables
character_pos = [SCREEN_WIDTH // 2, SCREEN_HEIGHT // 2]
character_speed = 5
monster_pos = [random.randint(50, SCREEN_WIDTH - 50), random.randint(50, SCREEN_HEIGHT - 50)]
score, health = 0, 100
questions = []  # Stores user-input questions and answers
unanswered_questions = []  # Tracks questions that still need to be asked
answering_question = False
current_question, correct_answer = '', ''
user_answer = ''
last_kill_time = time.time()
input_mode = "choose_count"  # Modes: 'choose_count', 'setup', 'game', 'end_game'
setup_question, setup_answer = '', ''
is_entering_question = True  # Toggle between question and answer input
question_index = 0
question_count = ''  # Stores the user's input for question count
health_goal = ''  # Stores the user's input for health goal
target_health = 0  # Final target health goal after input

# Initialize Screen
screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
pygame.display.set_caption("Ghostbuster Quiz Quest")

# Helper Functions
def draw_text(text, pos, color=WHITE, font=FONT):
    rendered_text = font.render(text, True, color)
    screen.blit(rendered_text, pos)

def draw_centered_text(text, y, color=WHITE, font=LARGE_FONT):
    rendered_text = font.render(text, True, color)
    text_rect = rendered_text.get_rect(center=(SCREEN_WIDTH // 2, y))
    screen.blit(rendered_text, text_rect)

def check_collision(pos1, pos2):
    return pygame.Rect(pos1[0], pos1[1], 40, 40).colliderect(pygame.Rect(pos2[0], pos2[1], 40, 40))

def spawn_monster():
    new_monster_pos = [random.randint(50, SCREEN_WIDTH - 50), random.randint(50, SCREEN_HEIGHT - 50)]
    while check_collision(new_monster_pos, character_pos):
        new_monster_pos = [random.randint(50, SCREEN_WIDTH - 50), random.randint(50, SCREEN_HEIGHT - 50)]
    return new_monster_pos

# Drawing the Ghostbuster
def draw_ghostbuster(pos):
    pygame.draw.rect(screen, GREEN, (pos[0], pos[1], 30, 40), border_radius=5)
    pygame.draw.circle(screen, GREEN, (pos[0] + 15, pos[1] - 10), 15)

# Drawing a Ghost with Face
def draw_ghost(pos):
    pygame.draw.circle(screen, LIGHT_BLUE, pos, 20)
    pygame.draw.circle(screen, BLACK, (pos[0] - 5, pos[1] - 5), 3)  # Left eye
    pygame.draw.circle(screen, BLACK, (pos[0] + 5, pos[1] - 5), 3)  # Right eye
    pygame.draw.arc(screen, BLACK, (pos[0] - 10, pos[1] - 5, 20, 10), 3.14, 2 * 3.14, 2)  # Mouth

# Game Loop
running = True
while running:
    screen.fill(BACKGROUND_COLOR)

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.KEYDOWN:
            # Health Goal Input Phase
            if input_mode == "choose_count":
                if event.key == pygame.K_RETURN:
                    if question_count.isdigit() and int(question_count) > 0:
                        question_count = int(question_count)
                        input_mode = "health_goal"
                    else:
                        question_count = ''  # Reset if invalid input
                elif event.key == pygame.K_BACKSPACE:
                    question_count = question_count[:-1]
                else:
                    question_count += event.unicode

            # Health Goal Setup Phase
            elif input_mode == "health_goal":
                if event.key == pygame.K_RETURN:
                    if health_goal.isdigit() and int(health_goal) > 0:
                        target_health = int(health_goal)
                        input_mode = "setup"  # Proceed to question setup
                    else:
                        health_goal = ''  # Reset if invalid input
                elif event.key == pygame.K_BACKSPACE:
                    health_goal = health_goal[:-1]
                else:
                    health_goal += event.unicode

            # Question Setup Phase
            elif input_mode == "setup":
                if event.key == pygame.K_RETURN:
                    if is_entering_question:
                        is_entering_question = False
                    else:
                        questions.append((setup_question, setup_answer))
                        setup_question, setup_answer = '', ''
                        is_entering_question = True
                        question_index += 1
                        if question_index >= question_count:
                            input_mode = "game"  # Start the game after questions
                            unanswered_questions = questions.copy()
                            monster_pos = spawn_monster()
                elif event.key == pygame.K_BACKSPACE:
                    if is_entering_question:
                        setup_question = setup_question[:-1]
                    else:
                        setup_answer = setup_answer[:-1]
                else:
                    if is_entering_question:
                        setup_question += event.unicode
                    else:
                        setup_answer += event.unicode

            # Game Mode - Answering questions
            elif input_mode == "game" and answering_question:
                if event.key == pygame.K_RETURN:
                    if user_answer.lower() == correct_answer.lower():
                        score += 1
                        unanswered_questions.remove((current_question, correct_answer))
                    else:
                        health -= 10
                    answering_question = False
                    user_answer = ''
                    monster_pos = spawn_monster()
                    last_kill_time = time.time()
                elif event.key == pygame.K_BACKSPACE:
                    user_answer = user_answer[:-1]
                else:
                    user_answer += event.unicode

    keys = pygame.key.get_pressed()
    if input_mode == "game" and not answering_question:
        if keys[pygame.K_LEFT]: character_pos[0] -= character_speed
        if keys[pygame.K_RIGHT]: character_pos[0] += character_speed
        if keys[pygame.K_UP]: character_pos[1] -= character_speed
        if keys[pygame.K_DOWN]: character_pos[1] += character_speed

    # Health Timer Check
    if input_mode == "game" and time.time() - last_kill_time > 15:
        health -= 10
        last_kill_time = time.time()

    # Check Collision with Monster
    if input_mode == "game" and check_collision(character_pos, monster_pos) and not answering_question:
        if unanswered_questions:
            answering_question = True
            current_question, correct_answer = random.choice(unanswered_questions)
        else:
            input_mode = "end_game"

    # Draw Setup or Game Screen
    if input_mode == "choose_count":
        draw_centered_text("Enter the number of questions:", SCREEN_HEIGHT // 2 - 100)
        draw_centered_text(question_count, SCREEN_HEIGHT // 2)
    elif input_mode == "health_goal":
        draw_centered_text("Enter your health goal:", SCREEN_HEIGHT // 2 - 100)
        draw_centered_text(health_goal, SCREEN_HEIGHT // 2)
    elif input_mode == "setup":
        if is_entering_question:
            draw_centered_text(f"Enter question {question_index + 1}: {setup_question}", SCREEN_HEIGHT // 2 - 100)
        else:
            draw_centered_text(f"Enter answer: {setup_answer}", SCREEN_HEIGHT // 2)
    elif input_mode == "game":
        draw_ghostbuster(character_pos)  # Draw ghostbuster character
        draw_ghost(monster_pos)  # Draw ghost
        pygame.draw.rect(screen, BLUE, (10, 10, health * 2, 20))
        draw_text(f"Score: {score}", (10, 40))

        # Flashcard-style Question Overlay
        if answering_question:
            pygame.draw.rect(screen, WHITE, (100, 150, 600, 300), border_radius=15)
            pygame.draw.rect(screen, BLACK, (100, 150, 600, 300), 3, border_radius=15)
            draw_centered_text("Question:", 180)
            draw_centered_text(current_question, 220, color=BLACK)
            draw_centered_text("Your Answer: " + user_answer, 260, color=BLACK)
    elif input_mode == "end_game":
        if health >= target_health:
            draw_centered_text("You have reached your goal!", SCREEN_HEIGHT // 2)
        else:
            draw_centered_text("You did not reach your goal.", SCREEN_HEIGHT // 2)
        pygame.display.flip()
        time.sleep(3)
        running = False

    # Check Game Over
    if health <= 0:
        draw_centered_text("Game Over!", SCREEN_HEIGHT // 2)
        pygame.display.flip()
        time.sleep(2)
        running = False

    pygame.display.flip()
    pygame.time.Clock().tick(30)

pygame.quit()
