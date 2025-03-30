-- @ScriptType: LocalScript
--// INSTANCES
local oo = script.Parent:WaitForChild("1_1")
local ot = script.Parent:WaitForChild("1_2")
local to = script.Parent:WaitForChild("2_1")
local tt = script.Parent:WaitForChild("2_2")

local b1 = script.Parent:WaitForChild("bias1")
local b2 = script.Parent:WaitForChild("bias2")

local error_label = script.Parent:WaitForChild("percenterror")
local best_label = script.Parent:WaitForChild("bestpercenterror")
local goal: number -- How much error you will let slide (in this case how many squares b/c there's 100 squares)
local goal_box = script.Parent:WaitForChild("goal_box")

--// GRAPH
local graph = {
	[1] = {1,3,7};
	[2] = {4,3,2};
	[3] = {1,5,6};
	[4] = {1,2,3};
	[5] = {1,9,8};
	[6] = {3,5,7};
}

local fullRange = {
	[1] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
	[2] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
	[3] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
	[4] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
	[5] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
	[6] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
	[7] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
	[8] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
	[9] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
	[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
}

--// COMBINATIONS
local attempted = {}

--// UI
local correctGraph = script.Parent:WaitForChild("CorrectContainer")
local estimateGraph = script.Parent:WaitForChild("EstimateContainer")

local safeColor = Color3.fromRGB(57, 255, 64)
local poisonousColor = Color3.fromRGB(255, 64, 64)

--// WEIGHTS
local weight_1_1: number, weight_2_1: number; -- Output 1
local weight_1_2: number, weight_2_2: number; -- Output 2

--// BIASES
local bias_1, bias_2

--// PERCENT ERROR
local percent_error = 100
local best_error = percent_error
local RNG = Random.new()

--// BACKGROUND TASK(S)
task.spawn(function()
	while task.wait() do
		--// WEIGHTS
		weight_1_1 = tonumber(oo.Text)
		weight_2_1 = tonumber(to.Text)

		weight_1_2 = tonumber(ot.Text)
		weight_2_2 = tonumber(tt.Text)

		--// BIASES
		bias_1 = tonumber(b1.Text)
		bias_2 = tonumber(b2.Text)

	end
end)

local setup = coroutine.wrap(function()
	while task.wait() do
		goal = tonumber(goal_box.Text)
	end
end)

setup()

--// FUNCTION DEFINITIONS
function find_error()
	--// ERROR
	local mismatched = 0

	for i, v in pairs(estimateGraph:GetChildren()) do
		--task.wait()
		if v:IsA("Frame") then
			if not(correctGraph:FindFirstChild(v.Name).BackgroundColor3 == v.BackgroundColor3) then
				mismatched += 1
			end
		end
	end

	percent_error = mismatched
	error_label.Text = percent_error.."%"
	print(percent_error)
end

function setColor(graph:Frame, x:number, y:number, color:Color3)
	graph[x.."_"..y].BackgroundColor3 = color;
	return true
end

function Classify(input1:number, input2:number): number
	local output1: number, output2: number;

	output1 = input1*weight_1_1 + input2*weight_2_1 + bias_1;
	output2 = input1*weight_1_2 + input2*weight_2_2 + bias_2;

	if (output1 > output2) then
		return 0;

	elseif (output2 >= output1) then
		return 1;

	end
end

function Visualize(graphX:number, graphY:number)
	local predictedClass:number = Classify(graphX, graphY);

	if (predictedClass == 0) then
		--print("("..graphX..", "..graphY..") is predicted to be safe")
		setColor(estimateGraph, graphX, graphY, safeColor)

	elseif (predictedClass == 1) then
		--print("("..graphX..", "..graphY..") is predicted to be poisonous")
		setColor(estimateGraph, graphX, graphY, poisonousColor)

	end
end

function VisualizeAnswer(graphX:number, graphY:number)
	if (graphX > 4) and (graphY > 5) then
		--print("("..graphX..", "..graphY..") is predicted to be safe")
		setColor(correctGraph, graphX, graphY, safeColor)

	else
		--print("("..graphX..", "..graphY..") is predicted to be poisonous")
		setColor(correctGraph, graphX, graphY, poisonousColor)

	end
end

function Run()
	for x, table in pairs(fullRange) do
		for i, y in pairs(table) do
			Visualize(x, y)
		end
	end

	find_error()
	
	if percent_error < best_error then
		best_error = percent_error
		best_label.Text = tostring(best_error).."%"
	end
end

--// INITIALIZATION
for x, table in pairs(fullRange) do
	for i, y in pairs(table) do
		VisualizeAnswer(x, y)
	end
end

--// CODE
script.Parent:WaitForChild("run").MouseButton1Click:Connect(function()
	--Run()

	while percent_error > goal do
		local combo: {string}

		repeat
			oo.Text = tostring(RNG:NextNumber(-15,15))
			ot.Text = tostring(RNG:NextNumber(-15,15))
			to.Text = tostring(RNG:NextNumber(-15,15))
			tt.Text = tostring(RNG:NextNumber(-15,15))
			b1.Text = tostring(RNG:NextNumber(-15,15))
			b2.Text = tostring(RNG:NextNumber(-15,15))
			combo = {oo.Text, ot.Text, to.Text, tt.Text, b1.Text, b2.Text}
		until (combo ~= nil) and not(table.find(attempted, combo))

		table.insert(attempted, combo)
		Run()
		task.wait()
	end

end)

oo.InputEnded:Connect(Run)
ot.InputEnded:Connect(Run)
to.InputEnded:Connect(Run)
tt.InputEnded:Connect(Run)
b1.InputEnded:Connect(Run)
b2.InputEnded:Connect(Run)

oo.Changed:Connect(Run)
ot.Changed:Connect(Run)
to.Changed:Connect(Run)
tt.Changed:Connect(Run)
b1.Changed:Connect(Run)
b2.Changed:Connect(Run)