extends PanelContainer

func activate(which_horsey: Horsey):
	$Label.text = which_horsey.display_name
