// Get references to HTML elements
const taskInput = document.getElementById('taskInput');
const addTaskButton = document.getElementById('addTaskButton');
const taskList = document.getElementById('taskList');

// Add event listener to the button to add a new task
addTaskButton.addEventListener('click', function() {
  const taskText = taskInput.value.trim();
  if (taskText !== '') {
    addTask(taskText);
    taskInput.value = '';  // Clear the input field
  }
});

// Function to add a new task to the list
function addTask(taskText) {
  const li = document.createElement('li');
  li.textContent = taskText;

  // Create a delete button for the task
  const deleteButton = document.createElement('button');
  deleteButton.textContent = 'Delete';
  deleteButton.className = 'delete-btn';

  // When the delete button is clicked, remove the task from the list
  deleteButton.addEventListener('click', function() {
    taskList.removeChild(li);
  });

  // Append the delete button to the task item and add it to the list
  li.appendChild(deleteButton);
  taskList.appendChild(li);
}
