vim.api.nvim_create_user_command(
    'PrintThing',
    function(opts)
      print("Hi, I am doing things")
      print(opts)
      print(opts.args)
    end,
	  { nargs = '?', range = '%', addr = 'arguments'}
)
